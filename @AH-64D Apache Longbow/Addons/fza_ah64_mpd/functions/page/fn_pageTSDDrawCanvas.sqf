#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
params ["_heli", "_canvas", "_mpdIndex", "_state", "_persistState"];


// Dynamic positioning
private _tsdScale = 0.125 * 5 / (_persistState get "tsdScale");
private _pos = getPosASL _heli;
private _ctrX = 0.5;  
private _ctrY = 0.75 - 0.25 * (_persistState get "ctr");

//Route Draw
private _routeData    = _heli getVariable "fza_ah64_routeData";
private _routeCurrent = _heli getVariable "fza_ah64_routeSelected";
private _routeInfo    = _routeData # _routeCurrent;
private _drawArray = [];
{
    private _previousIndex = (_foreachindex - 1);
    private _previousPoint = (_routeInfo#_previousIndex);
    if (_previousPoint isEqualTo _x && _previousIndex > -1) then {
        continue;
    };
    _drawArray pushback ([_heli, _X, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue);
} foreach _routeInfo;
{
    if ((_foreachindex + 1) >= count _drawArray) then {continue;};
    [_heli, _canvas, _X, _drawArray #(_foreachindex+1), [0, 1, 0, 1], MPD_POSMODE_WORLD, _tsdScale, [_ctrX, _ctrY]] call fza_mpd_fnc_canvasDrawLine;
} foreach _drawArray;

//Route Dir Draw
private _rteDir = _heli getVariable "fza_dms_routeNext";
if (_rteDir#1 isnotEqualTo [0,0,0]) then {
    [_heli, _canvas, _rteDir#1, [_heli, _rteDir#0, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue, [0, 1, 0, 1], MPD_POSMODE_WORLD, _tsdScale, [_ctrX, _ctrY]] call fza_mpd_fnc_canvasDrawLine;
};

//TSD Sensor line
private _posheli = getPosASL _heli;
private _posTadsTgt = [-1,-1,-1];
private _tadsAzimuth = _heli getVariable "fza_ah64_tadsAzimuth";
private _targetAzimuth = (_tadsAzimuth + direction _heli) mod 360;
private _sightCpg = [_heli, "fza_ah64_sight" , "cpg"] call fza_fnc_getSeatVariable;
private _range = _heli getVariable ["fza_ah64_tadsRange", 3000];

if (!isNull laserTarget _heli) then {
    _range = _heli distance laserTarget _heli;
    _heli setVariable ["fza_ah64_tadsRange", _range];
};

_posTadsTgt = [_posheli, _range, _targetAzimuth] call BIS_fnc_relPos;
_heli setVariable ["fza_ah64_tadsTarget", _posTadsTgt];

if (_posTadsTgt isnotEqualTo [-1,-1,-1] && _sightCpg isEqualTo SIGHT_TADS) then {
    [_heli, _canvas, _posTadsTgt, _posheli, [0, 1, 0, 1], MPD_POSMODE_WORLD, _tsdScale, [_ctrX, _ctrY]] call fza_mpd_fnc_canvasDrawLine;
};