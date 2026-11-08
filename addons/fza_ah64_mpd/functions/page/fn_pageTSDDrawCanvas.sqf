#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"
params ["_heli", "_canvas", "_mpdIndex", "_state", "_persistState"];
if ((_state get "subPageVarPage") isEqualTo TSD_RTE_RTM) exitWith {};


// Dynamic positioning
private _tsdScale = [_persistState] call fza_mpd_fnc_tsdScale;
private _pos = getPosASL _heli;
private _ctrX = 0.5;
private _ctrY = 0.75 - 0.25 * (_persistState get "ctr");
// The map's frame, live or frozen (fza_mpd_fnc_tsdFrame)
([_heli, _persistState] call fza_mpd_fnc_tsdFrame) params ["_framePos", "_frameHeading"];

[_heli, _canvas, _mpdIndex, _state, _persistState, _framePos, _frameHeading, _tsdScale, [_ctrX, _ctrY]] call fza_mpd_fnc_tsdZoneDrawCanvas;

//Route Draw
private _routeData    = _heli getVariable "fza_ah64_routeData";
private _routeCurrent = _heli getVariable "fza_ah64_routeSelected";
private _routeInfo    = _routeData # _routeCurrent;
private _drawArray = [];
{
    private _previousIndex = (_forEachindex - 1);
    private _previousPoint = (_routeInfo#_previousIndex);
    if (_previousPoint isEqualTo _x && _previousIndex > -1) then {
        continue;
    };
    _drawArray pushBack ([_heli, _X, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue);
} forEach _routeInfo;
{
    if ((_forEachindex + 1) >= count _drawArray) then {continue;};
    [_heli, _canvas, _X, _drawArray #(_forEachindex+1), [0, 1, 0, 1], MPD_POSMODE_WORLD, _tsdScale, [_ctrX, _ctrY], _frameHeading, _framePos, 0.004, TSD_MAP_CLIP] call fza_mpd_fnc_canvasDrawLine;
} forEach _drawArray;

//Route Dir Draw
private _rteDir = _heli getVariable "fza_dms_routeNext";
if (_rteDir#1 isNotEqualTo [0,0,0]) then {
    [_heli, _canvas, _rteDir#1, [_heli, _rteDir#0, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue, [0, 1, 0, 1], MPD_POSMODE_WORLD, _tsdScale, [_ctrX, _ctrY], _frameHeading, _framePos, 0.004, TSD_MAP_CLIP] call fza_mpd_fnc_canvasDrawLine;
};

//TSD Sensor line
private _posheli = getPosASL _heli;
private _posTadsTgt = [-1,-1,-1];
private _tadsAzimuth = _heli getVariable "fza_ah64_tadsAzimuth";
private _targetAzimuth = (_tadsAzimuth + direction _heli) mod 360;
private _sightCpg = [_heli, "fza_ah64_sight" , "cpg"] call fza_fnc_getSeatVariable;
// The CPG's TADS line runs out to the CPG's range source range
private _range = ([_heli, "cpg"] call fza_fnc_targetingRange) # 0;

_posTadsTgt = [_posheli, _range, _targetAzimuth] call BIS_fnc_relPos;
_heli setVariable ["fza_ah64_tadsTarget", _posTadsTgt];

if (_posTadsTgt isNotEqualTo [-1,-1,-1] && _sightCpg isEqualTo SIGHT_TADS) then {
    [_heli, _canvas, _posTadsTgt, _posheli, [0, 1, 0, 1], MPD_POSMODE_WORLD, _tsdScale, [_ctrX, _ctrY], _frameHeading, _framePos, 0.004, TSD_MAP_CLIP] call fza_mpd_fnc_canvasDrawLine;
};

//FCR footprint: the scan sector, turned with the centerline; GTM and RMAP out to 8 km at +-45/22.5/15/7.5 deg by the
// selected scan size, ATM out to 8 km at +-90/45/22.5 or the full circle in wide, TPM out to 2.5 km as on the FCR TPM
// page: +-45 deg narrow, and wide the arc cut by sides 1.75 km either side of the centerline, back to abeam the ownship
// and across. Green scanning continuously or idle, white for a single scan. Only with FCR as the crew station's sight,
// or as the CPG's second sight linked to the TADS (TADSL).
private _fcrMode = _heli getVariable ["fza_ah64_fcrMode", FCR_DISP_MODE_OFF];
private _ownSight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
if (_heli animationPhase "fcr_enable" == 1
    && {_ownSight == SIGHT_FCR || {player == gunner _heli && {_ownSight == SIGHT_TADS && {CPG_LINK(_heli)}}}}
    && {_fcrMode in [FCR_DISP_MODE_GTM, FCR_DISP_MODE_ATM, FCR_DISP_MODE_RMAP, FCR_DISP_MODE_TPM]}) then {
    private _atm     = _fcrMode == FCR_DISP_MODE_ATM;
    private _tpm     = _fcrMode == FCR_DISP_MODE_TPM;
    private _size    = _heli getVariable ["fza_ah64_fcrScanSize", 0];
    private _half    = [[[45, 22.5, 15, 7.5], [180, 90, 45, 22.5]] select _atm select _size, _heli getVariable ["fza_ah64_fcrTpmHalfFov", 90]] select _tpm;
    // The ATM antenna scans the negated bias (fza_fcr_fnc_armScanStart)
    private _bias    = (_heli getVariable ["fza_ah64_fcrAzBias", 0]) * ([1, -1] select _atm);
    private _center  = direction _heli + _bias;
    private _colour  = [[0, 1, 0, 1], [1, 1, 1, 1]] select (((_heli getVariable ["fza_ah64_fcrState", [FCR_MODE_OFF]]) # 0) == FCR_MODE_ON_SINGLE);
    private _radius  = [8000, 2500] select _tpm;
    private _at      = {params ["_bearing", ["_range", _radius]]; _posheli getPos [_range, _bearing]};
    private _line    = {[_heli, _canvas, _this # 0, _this # 1, _colour, MPD_POSMODE_WORLD, _tsdScale, [_ctrX, _ctrY], _frameHeading, _framePos, 0.004, TSD_MAP_CLIP] call fza_mpd_fnc_canvasDrawLine};

    private _tpmWide = _tpm && _half > 45;
    private _side    = 1750;
    private _arcHalf = [_half, asin (_side / _radius)] select _tpmWide;

    // The arc, in steps of at most 5 deg
    private _steps = ceil (2 * _arcHalf / 5);
    for "_i" from 0 to (_steps - 1) do {
        [[_center - _arcHalf + 2 * _arcHalf * _i / _steps] call _at, [_center - _arcHalf + 2 * _arcHalf * (_i + 1) / _steps] call _at] call _line;
    };
    if (_tpmWide) then {
        {
            private _abeam = [_center + _x, _side] call _at;
            [_abeam getPos [_radius * cos _arcHalf, _center], _abeam] call _line;
            [[_center + _x, 130] call _at, _abeam] call _line;
        } forEach [-90, 90];
    };
    // The sector edges from the ownship, none round the full circle
    if (_half < 180 && !_tpmWide) then {
        [[_center - _half, 130] call _at, [_center - _half] call _at] call _line;
        [[_center + _half, 130] call _at, [_center + _half] call _at] call _line;
    };
};
