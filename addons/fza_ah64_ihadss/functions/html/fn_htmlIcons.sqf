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
private _colour = [[0.1, 1, 0, 1], [1, 1, 1, 1]] select _headsDown;
private _shown  = [];
private _mode   = _heli getVariable ["fza_ah64_hmdfsmode", "trans"];
private _was    = _heli getVariable ["fza_ah64_was", WAS_WEAPON_NONE];

// Format edges the limited symbols hang on, the same as IH.EDGE in ihadss_common.js
private _edge = [_rectX + 170 / 640 * _rectW, _rectY + 100 / 480 * _rectH, _rectX + 495 / 640 * _rectW, _rectY + 400 / 480 * _rectH];

private _camASL = AGLToASL positionCameraToWorld [0, 0, 0];
private _dirToScreen = {
    worldToScreen ASLToAGL (_camASL vectorAdd (_this vectorMultiply 2000))
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
                ["flyTo", ("flyto" call _tex), (vectorNormalized _dir) call _dirToScreen, 64, true] call _place;
            };
        };
    };
};

// The pilot only gets the cued LOS reticle with CUEING selected; a weapon actioned stands in for it
private _curAcq = [_heli, [_heli] call fza_fnc_currentTurret] call fza_fnc_targetingCurAcq;
private _acqVec = [_heli, _curAcq] call fza_fnc_targetingAcqVec;
// World referenced symbols would be misplaced against the magnified TADS picture
if (!_tadsVideo && {player != driver _heli || _was != WAS_WEAPON_NONE} && {!isNil "_acqVec" && {vectorMagnitude _acqVec > 0}}) then {
    ["cued", ("cuedlos" call _tex), (vectorNormalized _acqVec) call _dirToScreen, 64] call _place;
};

private _sight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
if (isNil "_sight") then {_sight = SIGHT_HMD};

// Drawn like the cued LOS reticle, along the fixed gun
if (_was == WAS_WEAPON_GUN && _sight == SIGHT_FXD) then {
    ["gunFxd", ("cuedlos" call _tex), (vectorNormalized (_heli weaponDirection "fza_m230")) call _dirToScreen, 64] call _place;
};

// The reticle is inside the I-beam exactly when the pylons (+4 to -15 deg) can reach; steer onto it
if (_was == WAS_WEAPON_RKT && _sight != SIGHT_FXD) then {
    private _losAz = 0;
    switch (true) do {
        case (_headsDown || _sight == SIGHT_TADS): {
            _losAz = _heli getVariable ["fza_ah64_tadsAzimuth", 0];
        };
        case (_sight == SIGHT_FCR): {
            (_heli getVariable ["fza_ah64_fcrNts", [objNull, [0, 0, 0]]]) params [["_nts", objNull], ["_ntsPos", [0, 0, 0]]];
            if (!isNull _nts) then {_losAz = [_heli getRelDir _ntsPos] call CBA_fnc_simplifyAngle180};
        };
        default {
            (_heli vectorWorldToModelVisual ((AGLToASL positionCameraToWorld [0, 0, 1]) vectorDiff _camASL)) params ["_fx", "_fy"];
            _losAz = _fx atan2 _fy;
        };
    };
    private _pylonElev = _heli getVariable ["fza_ah64_rocketPylonElev", 0];
    private _inhibit   = (_heli getVariable ["fza_ah64_weaponInhibited", ""]) != "";
    // No stowed cursor until a WPN UTIL page can set ground stow
    private _rktTex    = ("rkt" + (["", "_inhibit"] select _inhibit)) call _tex;

    // Fixed size I-beam, bars 100 format units apart, moving so that full pylon travel is its own length: the top bar is
    // on the reticle at -15 deg, the bottom bar at +4 deg. Across, 16 units per degree.
    private _cx = ((320 + _losAz * 16) max 170) min 495;
    private _cy = ((290 - (_pylonElev + 15) / 19 * 100) max 100) min 400;
    ["rkt", _rktTex, [_rectX + _cx / 640 * _rectW, _rectY + _cy / 480 * _rectH], 128] call _place;
};

private _tpm = (_heli getVariable ["fza_ah64_fcrMode", 0]) == FCR_DISP_MODE_TPM;
if (_tpm && {!_tadsVideo} && {_heli getVariable ["fza_ah64_fcrcscope", false]} && {cameraView != "GUNNER"}) then {
    // TPM: the obstacle picture at structure tops, nearest first, on the HMD only
    {
        if (_forEachIndex > 63) exitWith {};
        if (count _x > 2) then {
            ["tgt" + str _forEachIndex, ("fcrObstacle" call _fcrTex), worldToScreen ASLToAGL _x, 30] call _place;
        };
    } forEach (_heli getVariable ["fza_ah64_fcrTPMObsDisplay", []]);
};

if (!_tpm && {!_tadsVideo} && {_heli animationPhase "fcr_enable" == 1} && {_heli getVariable ["fza_ah64_fcrcscope", false]}) then {
    private _fcrTargets = _heli getVariable ["fza_ah64_fcrDisplayTargets", []];
    _heli getVariable "fza_ah64_fcrLastScan" params ["", "_scanPos"];
    {
        if (_forEachIndex > 15) exitWith {};
        _x params ["_pos", "_type", "_moving"];
        private _ident = [_type, _scanPos distance2D _pos, _moving] call fza_mpd_fnc_buildFCRIdent;
        if (_ident != "") then {
            private _parts = _ident splitString "_";
            private _tgtTex = (toLower (_parts # 1) + (["", _parts # 2] select (_parts # 1 != "FLYER"))) call _fcrTex;
            ["tgt" + str _forEachIndex, _tgtTex, worldToScreen ASLToAGL _pos, 30] call _place;
        };
    } forEach _fcrTargets;

    private _ntsObj   = (_heli getVariable ["fza_ah64_fcrNts", [objNull]]) # 0;
    private _ntsIndex = _fcrTargets findIf {_x # 3 == _ntsObj};
    if (_ntsIndex != -1) then {
        ["nts", ((["nts", "nts_noMSL"] select (_was == WAS_WEAPON_NONE)) call _fcrTex), worldToScreen ASLToAGL ((_fcrTargets # _ntsIndex) # 0), 30] call _place;
        private _count = count _fcrTargets;
        if (_count > 1) then {
            ["ants", ("ants" call _fcrTex), worldToScreen ASLToAGL ((_fcrTargets # ((_ntsIndex + 1) mod (_count min 16))) # 0), 30] call _place;
        };
    };
};

{
    if !(_x in _shown) then {_y ctrlShow false};
} forEach _ctrls;
