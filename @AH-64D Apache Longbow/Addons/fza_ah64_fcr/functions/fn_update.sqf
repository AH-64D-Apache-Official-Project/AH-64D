/*----------------------------------------------------------------------------
Function: fza_fcr_fnc_update

Description:
    cycle the targeting system to the next FCR target

Parameters:
    _heli - the heli to act upon

Returns:
    Nothing
    
Examples:
    [_heli] call fza_fcr_fnc_cycleNTS;

Author:
    BradMick, Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_systems\headers\systems.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"
params ["_heli"];

if ((player != driver _heli) && (isplayer driver _heli)) exitwith {};

private _fcrDamage   = _heli getHitPointDamage "hit_msnequip_fcr";
private _fcrMode     = _heli Getvariable "fza_ah64_fcrMode";
private _fcrTracks   = getSensorTargets _heli;
private _fcrTargets  = [];

{
    _x params ["_target", "_type", "_relationship", "_sensor"];

    private _distOffAxis = abs ([_heli getRelDir _target] call CBA_fnc_simplifyAngle180);
    private _range       = _heli distance2d _target;
    private _heliPos     = getposasl _heli;
    private _targetpos   = getposasl _target;
    private _targetSpeed = speed _target;

    if (!("activeradar" in _sensor) || _heli getHit "radar" > 0.9) then { continue; };
    if (_range <= FCR_LIMIT_MIN_RANGE) then { continue; };
    if !(_range < FCR_LIMIT_STATIONARY_RANGE ||
       _targetspeed > FCR_LIMIT_MOVING_MIN_SPEED_KMH && _range < FCR_LIMIT_MOVING_RANGE) 
        then { continue; };
    if (count _fcrTargets > 256) exitwith {};

    _targDir = _heliPos vectorFromTo _targetpos;
    _zdist = _targDir vectorDotProduct vectorDir _heli;
    _ydist = _targDir vectorDotProduct vectorUp _heli;
    _xdist = sqrt (1 - _ydist^2 - _zdist^2);
    _elevAngle = _ydist atan2 _zdist;
    _aziAngle = _xdist atan2 _zdist;

    //Elevation
    if (_elevAngle > 25 && _fcrMode == 1) then {continue;};
    if (_elevAngle < -22.5 && _fcrMode == 2) then {continue;};
    //Azimuth
    if ((abs _aziAngle) > 45 && _fcrMode == 1) then {continue;};
    if ((abs _aziAngle) > 168 && _fcrMode == 2) then {continue;};

    // Find type
    private _type = FCR_TYPE_UNKNOWN;
    if (_target iskindof "tank")       then { _type = FCR_TYPE_TRACKED; };
    if (_target isKindOf "car")        then { _type = FCR_TYPE_WHEELED; };
    if (_target isKindOf "helicopter") then { _type = FCR_TYPE_HELICOPTER; };
    if (_target isKindOf "plane")      then { _type = FCR_TYPE_FLYER; };
    if ([_target] call fza_fnc_targetIsADA) then { _type = FCR_TYPE_ADU; };

    if ((_type != FCR_TYPE_FLYER && _type != FCR_TYPE_HELICOPTER) && _fcrMode == 2) then {continue;};
    if ((vectorMagnitude velocityModelSpace _target) < 5 && _fcrMode == 2) then {continue;};
    
    private _moving = (_targetSpeed >= FCR_LIMIT_MOVING_MIN_SPEED_KMH);
    if (_speed < 1) then {_speed = 0};
    _fcrTargets pushBack [getPosAsl _target, _type, _moving, _target];
} foreach _fcrTracks;

_fcrTargets = [_fcrTargets, [], {_x # 1}, "DESCEND"] call BIS_fnc_sortBy;

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

[_heli, "fza_ah64_fcrTargets", _fcrTargets] call fza_fnc_updateNetworkGlobal;
[_heli, "fza_ah64_fcrLastScan", [direction _heli, getposasl _heli, time]] call fza_fnc_updateNetworkGlobal;