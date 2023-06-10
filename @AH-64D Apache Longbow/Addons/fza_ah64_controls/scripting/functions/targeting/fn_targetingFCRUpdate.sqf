#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli"];

private _acBusOn = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn = _heli getVariable "fza_systems_dcBusOn";
Private _fcrMode = _heli Getvariable "fza_ah64_fcrMode";

if !(_acBusOn && _dcBusOn) exitwith {};

private _fcrTargets = [];
{
    _x params ["_target", "_type", "_relationship", "_sensor"];

    private _distOffAxis = abs ([_heli getRelDir _target] call CBA_fnc_simplifyAngle180);
    private _range       = _heli distance2d _target;
    if (!("activeradar" in _sensor) || _heli getHit "radar" > 0.9) then { continue; };
    if (_distOffAxis >= 45 && _fcrMode == 1) then { continue; };
    if !(_range < FCR_LIMIT_STATIONARY_RANGE ||
        speed _target > FCR_LIMIT_MOVING_MIN_SPEED_KMH && _range < FCR_LIMIT_MOVING_DIST) 
        then { continue; };

    // Find type
    private _type = FCR_TYPE_UNKNOWN;
    if (_target iskindof "tank")       then { _type = FCR_TYPE_TRACKED; };
    if (_target isKindOf "car")        then { _type = FCR_TYPE_WHEELED; };
    if (_target isKindOf "helicopter") then { _type = FCR_TYPE_HELICOPTER; };
    if (_target isKindOf "plane")      then { _type = FCR_TYPE_FLYER; };
    if ([_target] call fza_fnc_targetIsADA) then { _type = FCR_TYPE_ADU; };

    if ((_type != FCR_TYPE_FLYER && _type != FCR_TYPE_HELICOPTER) && _fcrMode == 2) then {continue};

    _fcrTargets pushBack [getPosAsl _target, _type, speed _target, _target];
} foreach getSensorTargets _heli;

_fcrTargets = [_fcrTargets, [], {_x # 0}, "DESCEND"] call BIS_fnc_sortBy;

private _oldNts = (_heli getVariable "fza_ah64_fcrNts") # 0;
private _newNtsIndex = _fcrTargets findIf {_x # 3 == _oldNts};
if (_newNtsIndex == -1) then {
    if (count _fcrTargets > 0) then {
        _newNtsIndex = 0; // If there isn't currently an NTS, pick the first
    };
};

if(_newNtsIndex == -1) then {
    _heli setVariable ["fza_ah64_fcrNts", [objNull,[0,0,0]], true];
} else {
    _heli setVariable ["fza_ah64_fcrNts", [_fcrTargets # _newNtsIndex # 3,_fcrTargets # _newNtsIndex # 0], true];
};

_heli setVariable ["fza_ah64_fcrTargets", _fcrTargets, true];
_heli setVariable ["fza_ah64_fcrLastScan", [direction _heli, getposasl _heli, time], true];