/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_tofEstimate

Description:
    The Hellfire's time of flight, estimated from the launch conditions: the
    missile flown along its trajectory to the target. Direct is the straight
    line; LO and HI climb (HELLFIRE_CLIMB_LO / _HI, at most a quarter of the
    range) to mid range and dive, a longer path. Along it the missile leaves
    the rail at its magazine's launch speed, the motor pushes it (thrust from
    initTime for thrustTime, up to maxSpeed) and drag acts on it
    (MISSILE_DRAG_SCALE x airFriction x speed squared).

Parameters:
    _ammo     - Missile CfgAmmo class
    _magazine - Its CfgMagazines class, for the launch speed
    _distance - Range to the target (m)
    _profile  - ACE attack profile: "hellfire" (direct), "hellfire_lo" or "hellfire_hi"

Returns:
    Time of flight (s)

Examples:
    [_ammo, _magazine, 4000, "hellfire_hi"] call fza_hellfire_fnc_tofEstimate

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_ammo", "_magazine", "_distance", ["_profile", "hellfire"]];

if (isNil "fza_hellfire_tofFlight") then {fza_hellfire_tofFlight = createHashMap};
private _flight = fza_hellfire_tofFlight get [_ammo, _magazine];
if (isNil "_flight") then {
    private _cfg = configFile >> "CfgAmmo" >> _ammo;
    _flight = [
        getNumber (configFile >> "CfgMagazines" >> _magazine >> "initSpeed"),
        getNumber (_cfg >> "thrust"),
        getNumber (_cfg >> "thrustTime"),
        getNumber (_cfg >> "initTime"),
        getNumber (_cfg >> "maxSpeed"),
        getNumber (_cfg >> "airFriction"),
        getNumber (_cfg >> "timeToLive")
    ];
    fza_hellfire_tofFlight set [[_ammo, _magazine], _flight];
};
_flight params ["_speed", "_thrust", "_thrustTime", "_initTime", "_maxSpeed", "_airFriction", "_timeToLive"];
private _drag = _airFriction * MISSILE_DRAG_SCALE;

private _climb = (switch (_profile) do {
    case "hellfire_lo": {HELLFIRE_CLIMB_LO};
    case "hellfire_hi": {HELLFIRE_CLIMB_HI};
    default {0};
}) min (_distance / 4);
private _path = 2 * sqrt ((_distance / 2) ^ 2 + _climb ^ 2);

private _dt = 0.05;
private _flown = 0;
private _t = 0;
while {_flown < _path && {_t < _timeToLive}} do {
    _flown = _flown + _speed * _dt;
    private _motor = _t >= _initTime && {_t < _initTime + _thrustTime} && {_speed < _maxSpeed};
    _speed = _speed + ((([0, _thrust] select _motor) - _drag * _speed * _speed) * _dt);
    if (_motor) then {_speed = _speed min _maxSpeed};
    _t = _t + _dt;
};
_t
