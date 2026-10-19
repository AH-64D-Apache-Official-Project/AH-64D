/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_htmlIcons

Description:
    Places the virtual (world referenced) IHADSS symbols as native picture
    controls, so they move in the same frame as the camera. The HTML page only
    carries symbols fixed to the format, which cannot lag head movement.

Parameters:
    _heli         - The helicopter
    _display      - The fza_ah64_ihadssIcons display
    _rect         - Screen rectangle [x, y, w, h] of the 640x480 format
    _headsDown    - True when the CPG is looking through the TADS
    _weaponFormat - True when the weapon symbology format is shown
    _tadsVideo    - True when the TADS picture is on the CPG's HDU

Returns:
    Nothing

Examples:
    --- Code
    [_heli, _display, _rect, false, false, false] call fza_ihadss_fnc_htmlIcons
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\bmkhs_helisim\functions\core\core.hpp"
#include "\fza_ah64_ihadss\headers\hdu.h"
disableSerialization;
params ["_heli", "_display", "_rect", "_headsDown", "_weaponFormat", ["_tadsVideo", false]];
_rect params ["_rectX", "_rectY", "_rectW", "_rectH"];

private _ctrls  = _display getVariable ["fza_ihadss_icons", createHashMap];
_display setVariable ["fza_ihadss_icons", _ctrls];
_display setVariable ["fza_ihadss_rect", _rect];

// The TPM profile canvas (fza_ihadss_fnc_cscopeProfileDraw) loads faded, so a new map never shows its default view with
// icons and names; shown two frames later, once its view far off the map has applied
private _profileCtrl = _display displayCtrl 652;
if (ctrlFade _profileCtrl > 0) then {
    private _firstFrame = _profileCtrl getVariable ["fza_ihadss_firstFrame", -1];
    if (_firstFrame < 0) then {
        _profileCtrl setVariable ["fza_ihadss_firstFrame", diag_frameNo];
    } else {
        if (diag_frameNo > _firstFrame + 1) then {
            _profileCtrl ctrlSetFade 0;
            _profileCtrl ctrlCommit 0;
        };
    };
};
private _colour = [[0.1, 1, 0, 1], [1, 1, 1, 1]] select _headsDown;
private _shown  = [];
private _mode   = _heli getVariable ["fza_ah64_hmdfsmode", "trans"];
private _was    = _heli getVariable ["fza_ah64_was", WAS_WEAPON_NONE];

// Format edges the limited symbols hang on, the same as IH.EDGE in ihadss_common.js; heads up the top moves up with the heading tape
private _edgeTop = 100 + ([IHADSS_SPREAD_TAPE, 0] select _headsDown);
private _edge = [_rectX + 170 / 640 * _rectW, _rectY + _edgeTop / 480 * _rectH, _rectX + 495 / 640 * _rectW, _rectY + 400 / 480 * _rectH];

private _camASL   = AGLToASL positionCameraToWorld [0, 0, 0];
private _camRight = (AGLToASL positionCameraToWorld [1, 0, 0]) vectorDiff _camASL;
private _camUp    = (AGLToASL positionCameraToWorld [0, 1, 0]) vectorDiff _camASL;
private _dirToScreen = {
    private _pos = worldToScreen ASLToAGL (_camASL vectorAdd (_this vectorMultiply 2000));
    if (_pos isNotEqualTo []) exitWith {_pos};
    // Off screen: far out from the screen centre in its direction, so an edge limited symbol is held at the edge
    private _right = _this vectorDotProduct _camRight;
    private _up    = _this vectorDotProduct _camUp;
    private _len   = sqrt (_right ^ 2 + _up ^ 2);
    if (_len < 1e-6) exitWith {[]};
    [0.5 + _right / _len * 10, 0.5 - _up / _len * 10]
};

private _tex    = {format ["\fza_ah64_ihadss\data\icons\ihadss_%1_ca.paa", _this]};
private _fcrTex = {format ["\fza_ah64_mpd\tex\fcrIcons\%1_ca.paa", _this]};

// [key, texture, screen position, size in format units, edge limited]
private _place = {
    params ["_key", "_texture", "_pos", "_units", ["_limit", false]];
    if (_pos isEqualTo []) exitWith {};
    _pos params ["_sx", "_sy"];
    if (_limit) then {
        private _limX = (_sx max (_edge # 0)) min (_edge # 2);
        private _limY = (_sy max (_edge # 1)) min (_edge # 3);
        // Edge limited symbols flash
        if ((_limX != _sx || _limY != _sy) && {floor (diag_tickTime * 4) mod 2 == 1}) then {
            _sx = -100;
        } else {
            _sx = _limX;
            _sy = _limY;
        };
    };
    if (_sx < _rectX || _sx > _rectX + _rectW || _sy < _rectY || _sy > _rectY + _rectH) exitWith {};
    // Heads up, kept inside the HDU lens and display field like the page's symbology
    if (!_headsDown && {
        private _fx = (_sx - _rectX) / _rectW * 640 - 320;
        private _fy = (_sy - _rectY) / _rectH * 480 - 240;
        _fx < HDU_FIELD_LEFT || {_fx > HDU_FIELD_RIGHT || {_fy < HDU_FIELD_TOP || {_fy > HDU_FIELD_BOTTOM
        || {((_fx * cos HDU_MASK_ROT + _fy * sin HDU_MASK_ROT) / HDU_CLIP_A) ^ 2 + ((_fy * cos HDU_MASK_ROT - _fx * sin HDU_MASK_ROT) / HDU_CLIP_B) ^ 2 > 1}}}}
    }) exitWith {};
    private _ctrl = _ctrls getOrDefault [_key, controlNull];
    if (isNull _ctrl) then {
        _ctrl = _display ctrlCreate ["RscPicture", -1];
        _ctrls set [_key, _ctrl];
    };
    if (ctrlText _ctrl != _texture) then {_ctrl ctrlSetText _texture};
    _ctrl ctrlSetTextColor _colour;
    private _h = _units / 480 * _rectH;
    private _w = _h / pixelH * pixelW;
    _ctrl ctrlSetPosition [_sx - _w / 2, _sy - _h / 2, _w, _h];
    _ctrl ctrlCommit 0;
    _ctrl ctrlShow true;
    _shown pushBack _key;
};

if (!_weaponFormat && !_headsDown) then {
    ["ht", ("headtracker" call _tex), (_heli vectorModelToWorldVisual [0, 1, 0]) call _dirToScreen, 64] call _place;

    if (_mode in ["trans", "cruise"]) then {
        // Over 5 kt ground speed, judged on the same no-wind vector it points along
        private _velWorld = _heli getVariable ["bmkhs_velWorldSpaceNoWind", [0, 0, 0]];
        if (vectorMagnitude _velWorld * MPS_TO_KNOTS > 5) then {
            ["fpv", ("fpv" call _tex), (vectorNormalized _velWorld) call _dirToScreen, 64, true] call _place;
        };
        private _nextPoint    = (_heli getVariable "fza_dms_routeNext") # 0;
        private _nextPointPos = [_heli, _nextPoint, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;
        if (!isNil "_nextPointPos") then {
            private _wptAlt = [_heli, _nextPoint, POINT_GET_ALT_MSL] call fza_dms_fnc_pointGetValue;
            if (isNil "_wptAlt") then {_wptAlt = getPosASL _heli # 2};
            private _dir = [_nextPointPos # 0, _nextPointPos # 1, _wptAlt] vectorDiff getPosASL _heli;
            if (vectorMagnitude _dir > 0) then {
                ["flyTo", ("flyto" call _tex), (vectorNormalized _dir) call _dirToScreen, 64] call _place;
            };
        };
    };
};

// With the TADS picture up, world points are placed in the picture, through the TADS LOS and the picture's FOV, not
// against the outside world. The picture's half height tangent is its FOV by the view's measured projection
// (fza_ihadss_fnc_viewScale), its half width that by the picture's aspect.
(missionNamespace getVariable ["fza_ihadss_tadsPicture", []]) params [["_picRect", []], ["_picFov", 0]];
private _inPicture = _tadsVideo && {_picRect isNotEqualTo [] && _picFov > 0};
private ["_picX", "_picY", "_picW", "_picH", "_picTanV", "_picTanH", "_tadsPos", "_tadsFwd", "_tadsRight", "_tadsUp"];
private _toPicture = {[]};
if (_inPicture) then {
    _picX = _picRect # 0;
    _picY = _picRect # 1;
    _picW = _picRect # 2;
    _picH = _picRect # 3;
    _picTanV   = _picFov * (([_heli] call fza_ihadss_fnc_viewScale) # 1);
    _picTanH   = _picTanV * (_picW / pixelW) / (_picH / pixelH);
    _tadsPos   = _heli modelToWorldVisualWorld (_heli selectionPosition "laserEnd");
    _tadsFwd   = [1, _heli getVariable ["fza_ah64_tadsAzimuth", 0], _heli getVariable ["fza_ah64_tadsElevation", 0]] call CBA_fnc_polar2vect;
    _tadsRight = vectorNormalized (_tadsFwd vectorCrossProduct [0, 0, 1]);
    _tadsUp    = _tadsRight vectorCrossProduct _tadsFwd;
    _toPicture = {
        private _d = _heli vectorWorldToModelVisual (_this vectorDiff _tadsPos);
        private _f = _d vectorDotProduct _tadsFwd;
        if (_f <= 0) exitWith {[]};
        [
            _picX + _picW / 2 * (1 + (_d vectorDotProduct _tadsRight) / _f / _picTanH),
            _picY + _picH / 2 * (1 - (_d vectorDotProduct _tadsUp) / _f / _picTanV)
        ]
    };
};

// Cued LOS reticle on the acquisition source, wherever it is cued (fza_fnc_targetingAcqCue), the same as the cueing
// dots. In the TADS picture when it is up.
private _turret = [_heli] call fza_fnc_currentTurret;
private _acqVec = [_heli, _turret] call fza_fnc_targetingAcqCue;
if (!isNil "_acqVec" && {vectorMagnitude _acqVec > 0}) then {
    private _cuedPos = if (_inPicture) then {
        ([_heli, [_heli, _turret] call fza_fnc_targetingCurAcq] call fza_fnc_targetingAcqPoint) call _toPicture
    } else {
        (vectorNormalized _acqVec) call _dirToScreen
    };
    ["cued", ("cuedlos" call _tex), _cuedPos, 64] call _place;
};

private _sight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
if (isNil "_sight") then {_sight = SIGHT_HMD};

// Drawn like the cued LOS reticle in MODE FXD, on the fixed gun's impact point at the range source range, so it moves
// down the display as the range grows. Solved 20 times a second and held relative to the aircraft between solutions.
private _gunMode = [_heli, "fza_ah64_gunMode"] call fza_fnc_getSeatVariable;
if (_was == WAS_WEAPON_GUN && {!isNil "_gunMode" && {_gunMode == "FXD"}}) then {
    private _impact = _heli getVariable ["fza_cannon_fxdImpact", [-1, [0, 0, 0]]];
    if (diag_tickTime - (_impact # 0) > 0.05) then {
        private _range = ([_heli, player] call fza_fnc_targetingRange) # 0;
        _impact = [diag_tickTime, _heli worldToModelVisual ASLToAGL ([_heli, _range] call fza_cannon_fnc_rangePoint)];
        _heli setVariable ["fza_cannon_fxdImpact", _impact];
    };
    private _dir = (AGLToASL (_heli modelToWorldVisual (_impact # 1))) vectorDiff _camASL;
    if (vectorMagnitude _dir > 0) then {
        ["gunFxd", ("cuedlos" call _tex), (vectorNormalized _dir) call _dirToScreen, 64] call _place;
    };
};

// The reticle is inside the I-beam exactly when the pylons can reach (+4 to -15 deg in the air, +4 to -5 deg on the
// ground, as PYLON LIMIT); steer onto it. Across, the rocket solution's azimuth from the nose (fza_hydra_fnc_aimSolve),
// with the lead, drift and pod offset the sight LOS lacks
if (_was == WAS_WEAPON_RKT) then {
    private _losAz     = _heli getVariable ["fza_ah64_rocketSteerAz", 0];
    private _pylonElev = _heli getVariable ["fza_ah64_rocketPylonElev", 0];
    private _inhibit   = (_heli getVariable ["fza_ah64_weaponInhibited", ""]) != "";
    // No stowed cursor until a WPN UTIL page can set ground stow
    private _rktTex    = ("rkt" + (["", "_inhibit"] select _inhibit)) call _tex;

    private _pylonMin  = [HYDRA_PYLON_MIN_AIR, HYDRA_PYLON_MIN_GROUND] select ([_heli] call bmkhs_fnc_stateOnGround);

    // Fixed size I-beam, bars 100 format units apart, moving so that full pylon travel is its own length: the top bar is
    // on the reticle at the lower limit, the bottom bar at the upper. Across, 16 units per degree.
    private _cx = ((320 + _losAz * 16) max 170) min 495;
    private _cy = ((290 - (_pylonElev - _pylonMin) / (HYDRA_PYLON_MAX - _pylonMin) * 100) max 100) min 400;
    ["rkt", _rktTex, [_rectX + _cx / 640 * _rectW, _rectY + _cy / 480 * _rectH], 128] call _place;
};

private _tpm = (_heli getVariable ["fza_ah64_fcrMode", 0]) == FCR_DISP_MODE_TPM;
if (_tpm && {!_tadsVideo} && {_heli getVariable ["fza_ah64_fcrcscope", false]} && {cameraView != "GUNNER"}) then {
    // TPM: the obstacle picture at structure tops, nearest first, on the HMD only; with NVS MODE FIXED where they are
    // in the fixed forward picture, as the C-scope lines (fza_ihadss_fnc_nvsFixedView)
    private _fixedView = [_heli] call fza_ihadss_fnc_nvsFixedView;
    {
        if (_forEachIndex > 63) exitWith {};
        if (count _x > 2) then {
            ["tgt" + str _forEachIndex, ("fcrObstacle" call _fcrTex), [_fixedView, _x] call fza_ihadss_fnc_nvsFixedToScreen, 30] call _place;
        };
    } forEach (_heli getVariable ["fza_ah64_fcrTPMObsDisplay", []]);
};

if (!_tpm && {_heli animationPhase "fcr_enable" == 1} && {_heli getVariable ["fza_ah64_fcrcscope", false]}) then {
    // In the TADS picture when it is up, otherwise against the outside world
    private _toScreen = [{worldToScreen ASLToAGL _this}, _toPicture] select _inPicture;

    private _fcrTargets = _heli getVariable ["fza_ah64_fcrDisplayTargets", []];
    _heli getVariable "fza_ah64_fcrLastScan" params ["", "_scanPos"];
    {
        if (_forEachIndex >= FCR_PAGE_NAV_PHASE_DISPLAY_TARGETS) exitWith {};
        _x params ["_pos", "_type", "_moving"];
        private _ident = [_type, _scanPos distance2D _pos, _moving] call fza_mpd_fnc_buildFCRIdent;
        if (_ident != "") then {
            private _parts = _ident splitString "_";
            private _tgtTex = (toLower (_parts # 1) + (["", _parts # 2] select (_parts # 1 != "FLYER"))) call _fcrTex;
            ["tgt" + str _forEachIndex, _tgtTex, _pos call _toScreen, 30] call _place;
        };
    } forEach _fcrTargets;

    private _ntsObj   = (_heli getVariable ["fza_ah64_fcrNts", [objNull]]) # 0;
    private _ntsIndex = _fcrTargets findIf {_x # 3 == _ntsObj};
    if (_ntsIndex != -1) then {
        ["nts", ((["nts", "nts_noMSL"] select (_was == WAS_WEAPON_NONE)) call _fcrTex), ((_fcrTargets # _ntsIndex) # 0) call _toScreen, 30] call _place;
        private _count = count _fcrTargets;
        if (_count > 1) then {
            ["ants", ("ants" call _fcrTex), ((_fcrTargets # ((_ntsIndex + 1) mod (_count min FCR_PAGE_NAV_PHASE_DISPLAY_TARGETS))) # 0) call _toScreen, 30] call _place;
        };
    };
};

{
    if !(_x in _shown) then {_y ctrlShow false};
} forEach _ctrls;
