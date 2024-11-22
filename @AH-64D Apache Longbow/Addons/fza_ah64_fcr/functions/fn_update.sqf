/*----------------------------------------------------------------------------
Function: fza_fcr_fnc_update;

Description:
    preprocess a snapshot of the FCR Final Scan for later post proccessing

Parameters:
    _heli

Returns:
    Nothing
    
Examples:
    [_heli] call fza_fcr_fnc_update;

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
    private _targetSpeed = vectorMagnitude velocity _target;

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
    _aziAngle = ([_heli getRelDir _target] call CBA_fnc_simplifyAngle180);

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

    if ((_type != FCR_TYPE_FLYER && _type != FCR_TYPE_HELICOPTER) && _targetSpeed < 5 && _fcrMode == 2) then {continue;};
    
    private _moving = (_targetSpeed >= FCR_LIMIT_MOVING_MIN_SPEED_KMH);
    _fcrTargets pushBack [[round (_targetpos#0),round (_targetpos#1),round (_targetpos#2)], _type, _moving, _target, [_aziAngle, 1] call BIS_fnc_cutDecimals, [_elevAngle, 1] call BIS_fnc_cutDecimals, _range];
} foreach _fcrTracks;
 

//proccess order
private _eval = {if(_x#6 < 4000)then{_x#4}else{_x#4 * -1 + 90};};
if (_fcrMode == 2) then {
    _eval = {if (_x#4 < 0) then {_x#4 * -1} else {_x#4};};
};
_fcrTargets = [_fcrTargets, [], _eval, "ASCEND"] call BIS_fnc_sortBy;

[_heli, "fza_ah64_fcrData", _fcrTargets] call fza_fnc_updateNetworkGlobal;
_heli getVariable "fza_ah64_fcrLastScan" params ["_dir", "_pos", "_time"]; 
[_heli, "fza_ah64_fcrLastScan", [direction _heli, getposasl _heli, time, _dir]] call fza_fnc_updateNetworkGlobal;