/* ----------------------------------------------------------------------------
Function: fza_fnc_ctrlVisUpdate

Description:
    Per-frame update for the Control Input Visualiser.
    Called from fza_ah64_draw3Darray every Draw3D event.

    Reads HeliSim/SFM+ variables and repositions all display controls to show:
      • Cyclic 2-D display   – actual stick (green O), FT reference (orange FT),
                               combined SAS+ATT hold command (red +)
      • Collective bar       – actual collective (green bar), alt-hold add-on (red)
      • Yaw / heading bar    – actual pedal (green |), FT pedal (orange |),
                               SAS yaw (red |)
      • Mode labels          – ALT / ATT-POS / VEL / ATT highlighted when active

Parameters:
    _heli - The helicopter object [Object]

Returns:
    Nothing

Author:
    FZA AH-64D Project
---------------------------------------------------------------------------- */
params ["_heli"];

// ── Guard conditions ─────────────────────────────────────────────────────────
private _display = uiNameSpace getVariable ["fza_ah64_ctrlvis", displayNull];
if (isNull _display) exitWith {};
if !(driver _heli == player || gunner _heli == player) exitWith {};
if !(_heli isKindOf "fza_ah64base") exitWith {};

// ── Layout parameters (position is owned by the Arma layout editor) ─────────
// We read the background control's current position; we never write it so the
// layout editor's saved position is always preserved.
// Note: the #define CTRL(idc) macro is declared below – use the full form here.
private _bgPos = ctrlPosition (_display displayCtrl 5101);
private _x0    = _bgPos select 0;
private _y0    = _bgPos select 1;
private _W     = _bgPos select 2;
private _H     = _bgPos select 3;

// Guard: background not yet positioned (very first frame edge-case)
if (_W < 0.001) exitWith {};

// Scale is derived from current height relative to the default height
private _scale = _H / (safeZoneH * 0.240);

// Row heights (fractions of _H)
private _dragH   = _H * 0.075;   // title / drag bar
private _modeH   = _H * 0.090;   // mode labels
private _mainH   = _H * 0.660;   // collective + cyclic area
private _yawH    = _H * 0.120;   // yaw / heading bar
// remaining 0.055 is a small bottom margin (legend fits here implicitly)

// Column widths
private _collW   = _W * 0.155;   // collective bar
private _cyclicW = _W - _collW;  // cyclic display

// Y anchors for each row
private _yDrag   = _y0;
private _yMode   = _y0 + _dragH;
private _yMain   = _y0 + _dragH + _modeH;
private _yYaw    = _y0 + _dragH + _modeH + _mainH;

private _fontSz  = _scale * safeZoneH * 0.018;  // used by yaw-bar pipe indicators
private _fontSzS = _scale * safeZoneH * 0.013;
private _indW    = _fontSz * 3.0;  // yaw-bar "|" rect width  (ST_CENTER needs room wider than glyph)
private _indH    = _fontSz;        // yaw-bar "|" rect height

// Cyclic indicator geometry (no font – pure rectangles, scale-invariant)
private _szSAS = _mainH * 0.042;  // SAS cross: full arm length
private _thSAS = _szSAS * 0.12;   // SAS cross: bar thickness (+20%)
private _szAct = _mainH * 0.06;   // actual ring outer diameter (= old FT size)
private _szFT  = _szAct * 0.5;    // FT ring: half actual diameter; baked-in 2× relative band → same absolute border thickness
// Aspect ratio correction: ensures rings are circular on any screen/UI-scale combination
private _res         = getResolution;
private _circleWAdj  = (safeZoneW / safeZoneH) / ((_res select 0) / (_res select 1));

// ── Read HeliSim variables ───────────────────────────────────────────────────
private _cycFwdAft    = _heli getVariable ["fza_sfmplus_cyclicFwdAft",           0.0]; // pitch (-1…1)
private _cycLeftRight = _heli getVariable ["fza_sfmplus_cyclicLeftRight",        0.0]; // roll  (-1…1)
private _ftPitch      = _heli getVariable ["fza_ah64_forceTrimPosPitch",         0.0];
private _ftRoll       = _heli getVariable ["fza_ah64_forceTrimPosRoll",          0.0];
private _ftPedal      = _heli getVariable ["fza_ah64_forceTrimPosPedal",         0.0];
private _sasPitch     = _heli getVariable ["fza_sfmplus_fmcSasPitchOut",         0.0];
private _sasRoll      = _heli getVariable ["fza_sfmplus_fmcSasRollOut",          0.0];
private _sasYaw       = _heli getVariable ["fza_sfmplus_fmcSasYawOut",           0.0];
private _attPitch     = _heli getVariable ["fza_sfmplus_fmcAttHoldCycPitchOut",  0.0];
private _attRoll      = _heli getVariable ["fza_sfmplus_fmcAttHoldCycRollOut",   0.0];
private _altColl      = _heli getVariable ["fza_sfmplus_fmcAltHoldCollOut",      0.0];
private _collective   = _heli getVariable ["fza_sfmplus_collectiveOutput",       0.0];
private _pedal        = _heli getVariable ["fza_sfmplus_pedalLeftRight",         0.0];

private _attHoldActive  = _heli getVariable ["fza_ah64_attHoldActive",  false];
private _attSubMode     = _heli getVariable ["fza_ah64_attHoldSubMode", "ATT"];
private _altHoldActive  = _heli getVariable ["fza_ah64_altHoldActive",  false];
private _hdgHoldActive  = _heli getVariable ["fza_ah64_hdgHoldActive",  false];
private _hdgHoldSubMode = _heli getVariable ["fza_ah64_hdgHoldSubMode", ""];

// SAS cyclic corrections only (FT reference is shown separately by the ◆ indicator)
private _sasTotalPitch = _sasPitch + _attPitch;
private _sasTotalRoll  = _sasRoll  + _attRoll;

// ── Colour scheme ────────────────────────────────────────────────────────────
// Index:  0=Default  1=NVG  2=Mono  3=Amber  4=BluFor  5=HiContrast
//         colAct = actual input  |  colFT = force-trim ref  |  colSAS = SAS/hold
private _colorScheme = fza_ah64_ctrlVisColor;
private _colAct = [
    [0.20,1.00,0.20,1.00],  // 0 Default   – bright green
    [0.20,1.00,0.20,1.00],  // 1 NVG        – bright green
    [1.00,1.00,1.00,1.00],  // 2 Mono       – white
    [1.00,0.75,0.00,1.00],  // 3 Amber      – amber
    [0.00,0.90,1.00,1.00],  // 4 BluFor     – cyan
    [1.00,1.00,1.00,1.00]   // 5 HiContrast – white
] select _colorScheme;
private _colFT = [
    [1.00,0.55,0.05,1.00],  // 0 Default   – orange
    [0.10,0.75,0.10,1.00],  // 1 NVG        – dark green
    [0.70,0.70,0.70,1.00],  // 2 Mono       – light grey
    [1.00,0.90,0.20,1.00],  // 3 Amber      – yellow
    [1.00,0.55,0.05,1.00],  // 4 BluFor     – orange (distinct from cyan actual)
    [1.00,1.00,0.00,1.00]   // 5 HiContrast – yellow
] select _colorScheme;
private _colSAS = [
    [1.00,0.15,0.15,1.00],  // 0 Default   – red
    [0.05,0.45,0.05,1.00],  // 1 NVG        – very dark green
    [0.45,0.45,0.45,1.00],  // 2 Mono       – mid grey
    [1.00,0.20,0.10,1.00],  // 3 Amber      – red
    [1.00,1.00,0.00,1.00],  // 4 BluFor     – yellow
    [1.00,0.15,0.15,1.00]   // 5 HiContrast – red
] select _colorScheme;

// Mode button and drag bar colours — per colour scheme
// Active text reuses _colAct (same scheme colour); inactive is always dim grey
private _colActive   = _colAct;
private _colInactive = [
    [0.60, 0.60, 0.60, 0.70],  // 0 Default
    [0.35, 0.55, 0.35, 0.70],  // 1 NVG        – muted green-grey
    [0.60, 0.60, 0.60, 0.70],  // 2 Mono
    [0.60, 0.50, 0.35, 0.70],  // 3 Amber      – warm grey
    [0.50, 0.65, 0.75, 0.70],  // 4 BluFor     – blue-grey
    [0.60, 0.60, 0.60, 0.90]   // 5 HiContrast
] select _colorScheme;
private _bgActive = [
    [0.00, 0.28, 0.00, 0.65],  // 0 Default   – dark green
    [0.00, 0.18, 0.00, 0.65],  // 1 NVG        – very dark green
    [0.20, 0.20, 0.20, 0.65],  // 2 Mono       – dark grey
    [0.28, 0.18, 0.00, 0.65],  // 3 Amber      – dark amber
    [0.00, 0.10, 0.35, 0.65],  // 4 BluFor     – dark blue
    [0.15, 0.15, 0.00, 0.90]   // 5 HiContrast – dark yellow
] select _colorScheme;
private _bgInactive = [0.00, 0.00, 0.00, 0.00];

private _colDragBg = [
    [0.05, 0.20, 0.05, 0.90],  // 0 Default   – dark green
    [0.02, 0.12, 0.02, 0.90],  // 1 NVG        – very dark green
    [0.12, 0.12, 0.12, 0.90],  // 2 Mono       – near black
    [0.18, 0.10, 0.00, 0.90],  // 3 Amber      – dark brown-amber
    [0.00, 0.06, 0.25, 0.90],  // 4 BluFor     – dark navy
    [0.00, 0.00, 0.00, 1.00]   // 5 HiContrast – pure black
] select _colorScheme;
private _colDragTxt = [
    [0.70, 1.00, 0.70, 1.00],  // 0 Default   – light green
    [0.30, 0.80, 0.30, 1.00],  // 1 NVG        – medium green
    [1.00, 1.00, 1.00, 1.00],  // 2 Mono       – white
    [1.00, 0.80, 0.20, 1.00],  // 3 Amber      – amber
    [0.60, 0.90, 1.00, 1.00],  // 4 BluFor     – light cyan
    [1.00, 1.00, 1.00, 1.00]   // 5 HiContrast – white
] select _colorScheme;

// ── Helper: shortcut to get a control ────────────────────────────────────────
#define CTRL(idc) (_display displayCtrl (idc))

// ── Drag bar ─────────────────────────────────────────────────────────────────
CTRL(5102) ctrlSetPosition       [_x0, _yDrag, _W, _dragH];
CTRL(5102) ctrlSetFontHeight     _fontSzS;
CTRL(5102) ctrlSetBackgroundColor _colDragBg;
CTRL(5102) ctrlSetTextColor       _colDragTxt;
CTRL(5102) ctrlCommit 0;

// ── Mode labels ──────────────────────────────────────────────────────────────
private _modeW = _W / 4;


// ALT
private _altActive = _altHoldActive;
CTRL(5110) ctrlSetPosition [_x0,              _yMode, _modeW, _modeH];
CTRL(5110) ctrlSetFontHeight _fontSzS;
CTRL(5110) ctrlSetTextColor       ([_colInactive, _colActive]   select _altActive);
CTRL(5110) ctrlSetBackgroundColor ([_bgInactive,  _bgActive]    select _altActive);
CTRL(5110) ctrlCommit 0;

// ATT-POS
private _attPosActive = _attHoldActive && (_attSubMode == "POS");
CTRL(5111) ctrlSetPosition [_x0 + _modeW,     _yMode, _modeW, _modeH];
CTRL(5111) ctrlSetFontHeight _fontSzS;
CTRL(5111) ctrlSetTextColor       ([_colInactive, _colActive]   select _attPosActive);
CTRL(5111) ctrlSetBackgroundColor ([_bgInactive,  _bgActive]    select _attPosActive);
CTRL(5111) ctrlCommit 0;

// VEL
private _velActive = _attHoldActive && (_attSubMode == "VEL");
CTRL(5112) ctrlSetPosition [_x0 + _modeW * 2, _yMode, _modeW, _modeH];
CTRL(5112) ctrlSetFontHeight _fontSzS;
CTRL(5112) ctrlSetTextColor       ([_colInactive, _colActive]   select _velActive);
CTRL(5112) ctrlSetBackgroundColor ([_bgInactive,  _bgActive]    select _velActive);
CTRL(5112) ctrlCommit 0;

// ATT (pure attitude hold – active when ATT hold on but not POS or VEL)
private _attActive = _attHoldActive && !(_attSubMode in ["POS","VEL"]);
CTRL(5113) ctrlSetPosition [_x0 + _modeW * 3, _yMode, _modeW, _modeH];
CTRL(5113) ctrlSetFontHeight _fontSzS;
CTRL(5113) ctrlSetTextColor       ([_colInactive, _colActive]   select _attActive);
CTRL(5113) ctrlSetBackgroundColor ([_bgInactive,  _bgActive]    select _attActive);
CTRL(5113) ctrlCommit 0;

// ── Collective bar ───────────────────────────────────────────────────────────
private _collPad   = _mainH * 0.04;
private _collRange = _mainH - (_collPad * 2);
private _collBarW  = _collW  * 0.88; // bar slightly narrower than column
private _collBarX  = _x0 + (_collW - _collBarW) * 0.5;

// Frame
CTRL(5120) ctrlSetPosition [_x0, _yMain, _collW, _mainH];
CTRL(5120) ctrlCommit 0;

// "C" label at top of collective column
CTRL(5123) ctrlSetPosition [_x0, _yMain, _collW, _dragH];
CTRL(5123) ctrlSetFontHeight _fontSzS;
CTRL(5123) ctrlCommit 0;

// Actual collective – a thin horizontal bar
private _lineH     = _H * 0.022;
private _collActY  = _yMain + (_mainH - _collPad) - (_collective * _collRange) - _lineH * 0.5;
CTRL(5121) ctrlSetPosition [_collBarX, _collActY, _collBarW, _lineH];
CTRL(5121) ctrlSetBackgroundColor _colAct;
CTRL(5121) ctrlCommit 0;

// Alt-hold collective add-on (red, only when alt hold engaged)
if (_altHoldActive) then {
    private _collTotal = [_collective + _altColl, 0.0, 1.0] call BIS_fnc_clamp;
    private _collSASY  = _yMain + (_mainH - _collPad) - (_collTotal * _collRange) - _lineH * 0.5;
    CTRL(5122) ctrlSetPosition [_collBarX, _collSASY, _collBarW, _lineH];
    CTRL(5122) ctrlSetBackgroundColor _colSAS;
    CTRL(5122) ctrlCommit 0;
    CTRL(5122) ctrlShow true;
} else {
    CTRL(5122) ctrlShow false;
};

// ── Cyclic 2D display ────────────────────────────────────────────────────────
private _cycX0 = _x0 + _collW;

CTRL(5130) ctrlSetPosition [_cycX0, _yMain, _cyclicW, _mainH];
CTRL(5130) ctrlCommit 0;

// Crosshair – centre of the cyclic display area
private _cxCtr = _cycX0 + _cyclicW * 0.50;
private _cyCtr = _yMain  + _mainH   * 0.50;
private _cxHW  = _cyclicW * 0.43;   // half-width available for indicator travel
private _cyHH  = _mainH   * 0.43;   // half-height available

private _lineThick = _H * 0.003;

// H crosshair
CTRL(5131) ctrlSetPosition [_cxCtr - _cxHW, _cyCtr - _lineThick * 0.5, _cxHW * 2, _lineThick];
CTRL(5131) ctrlCommit 0;

// V crosshair
CTRL(5132) ctrlSetPosition [_cxCtr - _lineThick * 0.5, _cyCtr - _cyHH, _lineThick, _cyHH * 2];
CTRL(5132) ctrlCommit 0;

// ── Cyclic indicators ────────────────────────────────────────────────────────
// Mapping:  roll  → X  (left -1, right +1)
//           pitch → Y  (fwd  +1 = up on display = smaller screen Y)

// ── Cyclic indicators (geometric rectangles – no font, no bias, scale-invariant) ─────────────
// All sizes are fractions of _H so they scale exactly with the layout editor.

// Actual physical stick (green ring) – top layer; transparency baked in ring_act_ca.paa
private _szActW = _szAct * _circleWAdj;  // width corrected for screen aspect ratio
private _actX = _cxCtr - _cycLeftRight * _cxHW;
private _actY = _cyCtr - _cycFwdAft   * _cyHH;
CTRL(5135) ctrlSetPosition [_actX - _szActW * 0.5, _actY - _szAct * 0.5, _szActW, _szAct];
CTRL(5135) ctrlSetTextColor _colAct;
CTRL(5135) ctrlCommit 0;

// Force trim reference (orange ring, ½ actual diameter) – middle layer; same absolute ring thickness
private _szFTW = _szFT * _circleWAdj;
private _ftX = _cxCtr - _ftRoll  * _cxHW;
private _ftY = _cyCtr - _ftPitch * _cyHH;
CTRL(5134) ctrlSetPosition [_ftX - _szFTW * 0.5, _ftY - _szFT * 0.5, _szFTW, _szFT];
CTRL(5134) ctrlSetTextColor _colFT;
CTRL(5134) ctrlCommit 0;

// SAS + ATT hold commanded position (red + cross) – bottom layer
// Clamped to ±1 so the indicators never leave the frame.
private _sasX = _cxCtr - ([_sasTotalRoll,  -1.0, 1.0] call BIS_fnc_clamp) * _cxHW;
private _sasY = _cyCtr - ([_sasTotalPitch, -1.0, 1.0] call BIS_fnc_clamp) * _cyHH;
CTRL(5133) ctrlSetPosition      [_sasX - _szSAS * 0.5, _sasY - _thSAS * 0.5, _szSAS, _thSAS]; // H bar
CTRL(5133) ctrlSetBackgroundColor _colSAS;
CTRL(5133) ctrlCommit 0;
CTRL(5136) ctrlSetPosition      [_sasX - _thSAS * 0.5, _sasY - _szSAS * 0.5, _thSAS, _szSAS]; // V bar
CTRL(5136) ctrlSetBackgroundColor _colSAS;
CTRL(5136) ctrlCommit 0;

// ── Yaw / heading bar ────────────────────────────────────────────────────────
private _yawBarX = _cycX0;
private _yawHW   = _cyclicW * 0.44;  // half-width for indicator travel
private _yawCtrX = _yawBarX + _cyclicW * 0.50;
private _yawCtrY = _yYaw + _yawH * 0.50;

CTRL(5140) ctrlSetPosition [_yawBarX, _yYaw, _cyclicW, _yawH];
CTRL(5140) ctrlCommit 0;

// HDG label — lit only when heading hold is active AND sub-mode is "hdg" (low-speed hover)
private _hdgLabelActive = _hdgHoldActive && (_hdgHoldSubMode == "hdg");
CTRL(5145) ctrlSetPosition       [_x0, _yYaw, _collW, _yawH];
CTRL(5145) ctrlSetFontHeight     _fontSzS;
CTRL(5145) ctrlSetTextColor       ([_colInactive, _colActive]  select _hdgLabelActive);
CTRL(5145) ctrlSetBackgroundColor ([_bgInactive,  _bgActive]   select _hdgLabelActive);
CTRL(5145) ctrlCommit 0;

// Centre tick
private _yawTickH = _yawH * 0.60;
private _yawTickW = _W    * 0.005;
CTRL(5144) ctrlSetPosition [_yawCtrX - _yawTickW * 0.5, _yawCtrY - _yawTickH * 0.5, _yawTickW, _yawTickH];
CTRL(5144) ctrlCommit 0;

// FT pedal (orange "|")
// "|" is symmetric – K=0.50; use _fontSz directly so this is independent of _indH
private _ftPedX = _yawCtrX + ([_ftPedal, -1.0, 1.0] call BIS_fnc_clamp) * _yawHW - _indW * 0.5;
private _ftPedY = _yawCtrY - _fontSz * 0.50;
CTRL(5141) ctrlSetPosition [_ftPedX, _ftPedY, _indW, _indH];
CTRL(5141) ctrlSetFontHeight _fontSz;
CTRL(5141) ctrlSetTextColor _colFT;
CTRL(5141) ctrlCommit 0;

// Actual pedal (green "|")
private _actPedX = _yawCtrX + ([_pedal, -1.0, 1.0] call BIS_fnc_clamp) * _yawHW - _indW * 0.5;
private _actPedY = _yawCtrY - _fontSz * 0.50;
CTRL(5142) ctrlSetPosition [_actPedX, _actPedY, _indW, _indH];
CTRL(5142) ctrlSetFontHeight _fontSz;
CTRL(5142) ctrlSetTextColor _colAct;
CTRL(5142) ctrlCommit 0;

// SAS yaw (red "|") — pure SAS correction only, independent of FT pedal
private _sasYawTotal = [_sasYaw, -1.0, 1.0] call BIS_fnc_clamp;
private _sasYawX     = _yawCtrX + _sasYawTotal * _yawHW - _indW * 0.5;
private _sasYawY     = _yawCtrY - _fontSz * 0.50;
CTRL(5143) ctrlSetPosition [_sasYawX, _sasYawY, _indW, _indH];
CTRL(5143) ctrlSetFontHeight _fontSz;
CTRL(5143) ctrlSetTextColor _colSAS;
CTRL(5143) ctrlCommit 0;

// Resize is handled by the Arma layout editor (CfgUIGrids) — no in-widget handle needed.
