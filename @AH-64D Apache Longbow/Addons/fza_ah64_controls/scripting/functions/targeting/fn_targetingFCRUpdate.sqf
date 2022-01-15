#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

if !isEngineOn _heli exitwith {};

private _fcrTargets = [];
{
	_x params ["_target", "_type", "_relationship", "_sensor"];

	private _distOffAxis = abs ([[_heli, (getposatl _heli select 0), (getposatl _heli select 1), (getposatl _target select 0), (getposatl _target select 1)] call fza_fnc_relativeDirection] call CBA_fnc_simplifyAngle180);
	private _range = _heli distance2d _target;
    if (!("activeradar" in _sensor) || _heli getHit "radar" > 0.9) then { continue; };
	if (_distOffAxis > 45) then { continue; };
    if (_range < FCR_LIMIT_MIN_RANGE) then { continue; };
    if !(_range < FCR_LIMIT_STATIONARY_DIST ||
        speed _target > FCR_LIMIT_MOVING_MIN_SPEED_KMH && _range < FCR_LIMIT_MOVING_DIST) 
        then { continue; };

    // Find type
    private _type = FCR_TYPE_UNKNOWN;
    if (_target iskindof "tank") then { _type = FCR_TYPE_TRACKED; };
    if (_target isKindOf "car") then { _type = FCR_TYPE_WHEELED; };
    if (_target isKindOf "helicopter") then { _type = FCR_TYPE_HELICOPTER; };
    if (_target isKindOf "plane") then { _type = FCR_TYPE_FLYER; };
    if ([_target] call fza_fnc_targetIsADA) then { _type = FCR_TYPE_ADU; };

	_fcrTargets pushBack [getPosAsl _target, _type, speed _target, _target];
} foreach getSensorTargets _heli;

_heli setVariable ["fza_ah64_fcrTargets", _fcrTargets, true];