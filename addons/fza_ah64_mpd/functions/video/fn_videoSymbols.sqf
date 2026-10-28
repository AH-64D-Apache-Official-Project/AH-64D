/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_videoSymbols

Description:
    The world referenced symbols of the VIDEO page's symbology, where they are
    in its video: through the camera of the sensor shown (its position, LOS and
    FOV) and the page's VIEW. With no video, the TADS's for the TADS symbology,
    otherwise that crew station's head at the PNVS's FOV. In the format's units,
    as the page lays the format over the MPD (480 units to its height,
    centred). The same symbols as the HDU's (fza_ihadss_fnc_htmlIcons): flight
    format, the head tracker, flight path vector and fly-to cue; the cued LOS
    reticle; the rocket steering cursor; the C-SCOPE FCR targets, or with TPM
    its obstacles and terrain profile lines.

Parameters:
    _heli      - The helicopter
    _target    - The video's render target (fza_mpd_fnc_videoSource), "" with none
    _view      - MPD_VIDEO_VIEW_*
    _symbology - The symbology shown with it, "TADS", "C-FLT" or "P-FLT"

Returns:
    [icons [[texture, x, y, size]], TPM lines [[line, [x, y, ...]]]]

Examples:
    --- Code
    [_heli, "fza_ah64_pnvscam2", MPD_VIDEO_VIEW_NORM, "P-FLT"] call fza_mpd_fnc_videoSymbols
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\bmkhs_helisim\functions\core\core.hpp"
params ["_heli", "_target", "_view", "_symbology"];

private _flight = _symbology in ["C-FLT", "P-FLT"];
private _turret = [[0], [-1]] select (_symbology == "P-FLT");

// The camera: the PNVS on its own, the TADS (its pictures and as an NVS sensor) on its LOS, or the crew station's head;
// its position (ASL) and LOS (model space)
private _pnvsFov = getNumber (configOf _heli >> "RenderTargets" >> "driverpnvs2" >> "View01" >> "fov");
private _camASL  = [];
private _fwd     = [];
private _fov     = _pnvsFov;
switch (true) do {
    case (_target == "fza_ah64_pnvscam2"): {
        private _camPos = _heli selectionPosition "driverview";
        _camASL = _heli modelToWorldVisualWorld _camPos;
        _fwd    = vectorNormalized ((_heli selectionPosition "driverview_dir") vectorDiff _camPos);
    };
    case (_target != "" || {_symbology == "TADS"}): {
        ([_heli] call fza_ihadss_fnc_tadsLos) params ["_tadsPos", "_tadsDir"];
        _camASL = _heli modelToWorldVisualWorld _tadsPos;
        _fwd    = _tadsDir;
        _fov    = if (_target == "fza_ah64_tadscam_nvs") then {
            getNumber (configOf _heli >> "RenderTargets" >> "gunnertads_nvs" >> "View01" >> "fov")
        } else {
            fza_ah64_tadsFOVs select (_heli getVariable ["fza_ihadss_tadsOpticsMode", _heli getTurretOpticsMode [0]])
        };
    };
    default {
        private _unit = [gunner _heli, driver _heli] select (_symbology == "P-FLT");
        if (isNull _unit) exitWith {};
        if (_unit == player) then {
            _camASL = AGLToASL positionCameraToWorld [0, 0, 0];
            _fwd    = _heli vectorWorldToModelVisual ((AGLToASL positionCameraToWorld [0, 0, 1]) vectorDiff _camASL);
        } else {
            _camASL = eyePos _unit;
            _fwd    = _heli vectorWorldToModelVisual eyeDirection _unit;
        };
    };
};
if (_fwd isEqualTo []) exitWith {[[], []]};
_fwd = vectorNormalized _fwd;
private _right = vectorNormalized (_fwd vectorCrossProduct [0, 0, 1]);
private _up    = _right vectorCrossProduct _fwd;
// Format units per unit of tangent: the picture's height in the MPD (fza_mpd_fnc_videoApply) over its half height
// tangent (fza_ihadss_fnc_viewScale); the format is 480 units to the MPD's height
private _picH = [1 / (4 / 3 * 0.95), 1 / (4 / 3 * 0.75), 2 / (4 / 3 * 0.95)] select _view;
private _k    = _picH / 2 * 480 / (_fov * (([_heli] call fza_ihadss_fnc_viewScale) # 1));

// Model space direction to the format, [] behind the camera or far outside the page; held out in its direction at the
// format's edge when _far. Only finite values in reach of the page.
private _project = {
    params ["_d", ["_far", false]];
    private _f = _d vectorDotProduct _fwd;
    private _r = _d vectorDotProduct _right;
    private _u = _d vectorDotProduct _up;
    private _pos = [];
    if (_f > 1e-3) then {_pos = [320 + _k * _r / _f, 240 - _k * _u / _f]};
    if (_far && {_pos isEqualTo [] || {abs ((_pos # 0) - 320) > 1000 || abs ((_pos # 1) - 240) > 1000}}) then {
        private _len = sqrt (_r ^ 2 + _u ^ 2);
        _pos = if (_len < 1e-6) then {[]} else {[320 + 1000 * _r / _len, 240 - 1000 * _u / _len]};
    };
    if (_pos isEqualTo [] || {!finite (_pos # 0) || !finite (_pos # 1) || abs ((_pos # 0) - 320) > 1000 || abs ((_pos # 1) - 240) > 1000}) exitWith {[]};
    [round ((_pos # 0) * 10) / 10, round ((_pos # 1) * 10) / 10]
};
private _point = {[_heli vectorWorldToModelVisual (_this vectorDiff _camASL)] call _project};
private _dir   = {[_heli vectorWorldToModelVisual _this, true] call _project};

private _ihTex  = {format ["\fza_ah64_ihadss\data\icons\ihadss_%1_ca.paa", _this]};
private _fcrTex = {format ["\fza_ah64_mpd\tex\fcrIcons\%1_ca.paa", _this]};

private _icons = [];
// [texture, format position, size in format units, edge limited]; limited symbols hang on the format's edges and flash there
private _place = {
    params ["_texture", "_pos", "_units", ["_limit", false]];
    if (_pos isEqualTo []) exitWith {};
    _pos params ["_px", "_py"];
    if (_limit) then {
        private _limX = (_px max 170) min 495;
        private _limY = (_py max 100) min 400;
        if ((_limX != _px || _limY != _py) && {floor (diag_tickTime * 4) mod 2 == 1}) exitWith {_px = -1e4};
        _px = _limX;
        _py = _limY;
    };
    if (abs (_px - 320) > 500 || abs (_py - 240) > 500) exitWith {};
    _icons pushBack [_texture, _px, _py, _units];
};

private _mode = _heli getVariable ["fza_ah64_hmdfsmode", "trans"];
private _was  = _heli getVariable ["fza_ah64_was", WAS_WEAPON_NONE];

if (_flight) then {
    ["headtracker" call _ihTex, [[0, 1, 0], true] call _project, 64] call _place;
    if (_mode in ["trans", "cruise"]) then {
        private _velWorld = _heli getVariable ["bmkhs_velWorldSpaceNoWind", [0, 0, 0]];
        if (vectorMagnitude _velWorld * MPS_TO_KNOTS > 5) then {
            ["fpv" call _ihTex, (vectorNormalized _velWorld) call _dir, 64, true] call _place;
        };
        private _nextPoint    = (_heli getVariable "fza_dms_routeNext") # 0;
        private _nextPointPos = [_heli, _nextPoint, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;
        if (!isNil "_nextPointPos") then {
            private _wptAlt = [_heli, _nextPoint, POINT_GET_ALT_MSL] call fza_dms_fnc_pointGetValue;
            if (isNil "_wptAlt") then {_wptAlt = getPosASL _heli # 2};
            ["flyto" call _ihTex, [_nextPointPos # 0, _nextPointPos # 1, _wptAlt] call _point, 64] call _place;
        };
    };
};

// Cued LOS reticle on the acquisition source's point, or along its LOS
private _acqVec = [_heli, _turret] call fza_fnc_targetingAcqCue;
if (!isNil "_acqVec" && {vectorMagnitude _acqVec > 0}) then {
    private _acqPoint = [_heli, [_heli, _turret] call fza_fnc_targetingCurAcq] call fza_fnc_targetingAcqPoint;
    ["cuedlos" call _ihTex, if (_acqPoint isEqualTo []) then {(vectorNormalized _acqVec) call _dir} else {_acqPoint call _point}, 64] call _place;
};

// Rocket steering cursor, fixed to the format (fza_ihadss_fnc_htmlIcons)
if (_was == WAS_WEAPON_RKT) then {
    private _losAz     = _heli getVariable ["fza_ah64_rocketSteerAz", 0];
    private _pylonElev = _heli getVariable ["fza_ah64_rocketPylonElev", 0];
    // Inhibited for the aiming crew station and those holding the rockets, as on that crew station's HMD
    private _symSeat   = ["cpg", "plt"] select (_symbology == "P-FLT");
    private _inhibit   = (_heli getVariable ["fza_ah64_weaponInhibited", ""]) != ""
        && {_symSeat in (_heli getVariable ["fza_ah64_wasSeats", []]) || {(_heli getVariable ["fza_ah64_weaponInhibitedSeat", ""]) == _symSeat}};
    private _pylonMin  = [HYDRA_PYLON_MIN_AIR, HYDRA_PYLON_MIN_GROUND] select ([_heli] call bmkhs_fnc_stateOnGround);
    private _cx = ((320 + _losAz * 16) max 170) min 495;
    private _cy = ((290 - (_pylonElev - _pylonMin) / (HYDRA_PYLON_MAX - _pylonMin) * 100) max 100) min 400;
    [("rkt" + (["", "_inhibit"] select _inhibit)) call _ihTex, [_cx, _cy], 128] call _place;
};

private _lines = [];
private _cscope = _heli getVariable ["fza_ah64_fcrcscope", false];
private _tpm    = (_heli getVariable ["fza_ah64_fcrMode", 0]) == FCR_DISP_MODE_TPM;
if (_tpm && {_cscope} && {_flight}) then {
    {
        if (_forEachIndex > 63) exitWith {};
        if (count _x > 2) then {["fcrObstacle" call _fcrTex, _x call _point, 30] call _place};
    } forEach (_heli getVariable ["fza_ah64_fcrTPMObsDisplay", []]);

    // Terrain profile lines, about 3 deg between points, a missing column or a point behind breaking a line
    private _lineCount = (_heli getVariable ["fza_ah64_fcrTpmLines", 4]) min 4;
    (_heli getVariable ["fza_ah64_fcrTPMProfile", []]) params [["_leftBearing", 0], ["_colWidth", 1], ["_profile", []]];
    if (_lineCount > 0 && {_profile isNotEqualTo []}) then {
        private _colCount = count (_profile # 0);
        private _stride   = (round (3 / _colWidth)) max 1;
        private _fwdWorld = _heli vectorModelToWorldVisual _fwd;
        private _camRel   = ((((_fwdWorld # 0) atan2 (_fwdWorld # 1)) - _leftBearing) + 720) % 360;
        if (_camRel > 270) then {_camRel = _camRel - 360};
        private _iFrom = (floor ((_camRel - 60) / _colWidth)) max 0;
        private _iTo   = (ceil ((_camRel + 60) / _colWidth)) min (_colCount - 1);
        _iFrom = _iFrom - (_iFrom % _stride);
        for "_li" from 0 to ((_lineCount min count _profile) - 1) do {
            private _run = [];
            for "_i" from _iFrom to _iTo step _stride do {
                private _p = (_profile # _li) # _i;
                private _s = if (_p isEqualTo []) then {[]} else {_p call _point};
                if (_s isEqualTo []) then {
                    if (count _run > 3) then {_lines pushBack [_li, _run]};
                    _run = [];
                } else {
                    _run append _s;
                };
            };
            if (count _run > 3) then {_lines pushBack [_li, _run]};
        };
    };
};

if (!_tpm && {_cscope} && {_heli animationPhase "fcr_enable" == 1}) then {
    private _fcrTargets = _heli getVariable ["fza_ah64_fcrDisplayTargets", []];
    _heli getVariable "fza_ah64_fcrLastScan" params ["", "_scanPos"];
    {
        if (_forEachIndex >= FCR_PAGE_NAV_PHASE_DISPLAY_TARGETS) exitWith {};
        _x params ["_pos", "_type", "_moving"];
        private _ident = [_type, _scanPos distance2D _pos, _moving] call fza_mpd_fnc_buildFCRIdent;
        if (_ident != "") then {
            private _parts = _ident splitString "_";
            [(toLower (_parts # 1) + (["", _parts # 2] select (_parts # 1 != "FLYER"))) call _fcrTex, _pos call _point, 30] call _place;
        };
    } forEach _fcrTargets;

    private _ntsObj   = (_heli getVariable ["fza_ah64_fcrNts", [objNull]]) # 0;
    private _ntsIndex = _fcrTargets findIf {_x # 3 == _ntsObj};
    if (_ntsIndex != -1) then {
        [(["nts", "nts_noMSL"] select (_was == WAS_WEAPON_NONE)) call _fcrTex, ((_fcrTargets # _ntsIndex) # 0) call _point, 30] call _place;
        private _count = count _fcrTargets;
        if (_count > 1) then {
            ["ants" call _fcrTex, ((_fcrTargets # ((_ntsIndex + 1) mod (_count min FCR_PAGE_NAV_PHASE_DISPLAY_TARGETS))) # 0) call _point, 30] call _place;
        };
    };
};

[_icons, _lines]
