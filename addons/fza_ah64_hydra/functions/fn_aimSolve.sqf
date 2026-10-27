/* ----------------------------------------------------------------------------
Function: fza_hydra_fnc_aimSolve

Description:
    The rocket's fire control solution: the direction that puts a rocket on a
    point. The rocket is stepped through its flight, as the cannon's solver
    steps its round, from its ammunition's config scaled to its flight as
    recorded in game (HYDRA_INIT_SPEED, HYDRA_THRUST_SCALE, HYDRA_DRAG_SCALE,
    HYDRA_SIDE_SCALE): it leaves the pod with the aircraft's velocity, its body
    along the pod, and its body keeps that direction. The motor pushes it along
    its body (thrust from initTime for thrustTime, up to maxSpeed). Drag
    (airFriction) slows its velocity along the body, side friction
    (sideAirFriction) its velocity across it, each by that component squared,
    and gravity acts on it.
    Steps of 0.05 s: each changes the velocity, the motor pushing for its share
    of the step, then moves the rocket by the step's average velocity.
    The aim is moved by the miss until it hits, starting from the last
    solution's correction, so a tracked point usually needs one flight. A
    moving target is led by its velocity over the rocket's time of flight.

Parameters:
    _heli      - The helicopter
    _target    - Point to hit (ASL)
    _targetVel - Its velocity (m/s), default still
    _offset    - The last solution's correction (aim point minus target), to start from
    _magazine  - Rocket pod CfgMagazines class, for its rocket

Returns:
    [world direction to fire along, time of flight (s), correction for the next solution]

Examples:
    [_heli, _targetASL] call fza_hydra_fnc_aimSolve

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_target", ["_targetVel", [0, 0, 0]], ["_offset", [0, 0, 0]], ["_magazine", ""]];

if (isNil "fza_hydra_ballistics") then {fza_hydra_ballistics = createHashMap};
private _ballistics = fza_hydra_ballistics get _magazine;
if (isNil "_ballistics") then {
    private _ammo = getText (configFile >> "CfgMagazines" >> _magazine >> "ammo");
    if (_ammo == "") then {_ammo = "fza_275_base"};
    private _cfg = configFile >> "CfgAmmo" >> _ammo;
    _ballistics = [
        getNumber (_cfg >> "thrust"),
        getNumber (_cfg >> "thrustTime"),
        getNumber (_cfg >> "initTime"),
        getNumber (_cfg >> "maxSpeed"),
        getNumber (_cfg >> "airFriction"),
        getNumber (_cfg >> "timeToLive"),
        [1, getNumber (_cfg >> "coefGravity")] select (isNumber (_cfg >> "coefGravity")),
        getNumber (_cfg >> "sideAirFriction")
    ];
    fza_hydra_ballistics set [_magazine, _ballistics];
};
_ballistics params ["_thrust", "_thrustTime", "_initTime", "_maxSpeed", "_airFriction", "_timeToLive", "_coefGravity", "_sideAirFriction"];

private _initSpeed = HYDRA_INIT_SPEED;
_thrust            = _thrust * HYDRA_THRUST_SCALE;
private _drag      = _airFriction * HYDRA_DRAG_SCALE;
private _side      = _sideAirFriction * HYDRA_SIDE_SCALE;

private _dt      = 0.05;
private _gravity = [0, 0, -9.80665 * _coefGravity * _dt];
private _launch  = _heli modelToWorldVisualWorld HYDRA_LAUNCH_POS(_heli);
private _heliVel = velocity _heli;
private _aim     = _target vectorAdd _offset;
private _tof     = 0;

private _miss    = 1e9;
for "_i" from 1 to 6 do {
    if (_miss < 0.5) exitWith {};
    // Where a moving target will be when this rocket arrives
    private _lead  = _target vectorAdd (_targetVel vectorMultiply _tof);
    private _dir   = _launch vectorFromTo _aim;
    private _reach = (_lead vectorDiff _launch) vectorDotProduct _dir;
    private _pos   = _launch;
    private _prev  = _launch;
    private _vel   = (_dir vectorMultiply _initSpeed) vectorAdd _heliVel;
    private _t     = 0;
    while {((_pos vectorDiff _launch) vectorDotProduct _dir) < _reach && {_t < _timeToLive}} do {
        _prev = _pos;
        // The body is the pod line: drag along it, side friction across it
        private _along  = _vel vectorDotProduct _dir;
        private _across = _vel vectorDiff (_dir vectorMultiply _along);
        private _accel  = _gravity vectorAdd (_dir vectorMultiply (-_drag * _along * abs _along * _dt));
        _accel = _accel vectorAdd (_across vectorMultiply (-_side * vectorMagnitude _across * _dt));
        // The motor's share of this step, s
        private _burn   = (((_t + _dt) min (_initTime + _thrustTime)) - (_t max _initTime)) max 0;
        private _motor  = _burn > 0 && {vectorMagnitude _vel < _maxSpeed};
        if _motor then {
            _accel = _accel vectorAdd (_dir vectorMultiply (_thrust * _burn));
        };
        private _newVel = _vel vectorAdd _accel;
        // The motor stops pushing at maxSpeed, within the step
        if (_motor && {vectorMagnitude _newVel > _maxSpeed}) then {
            _newVel = _newVel vectorMultiply (_maxSpeed / vectorMagnitude _newVel);
        };
        _pos = _pos vectorAdd ((_vel vectorAdd _newVel) vectorMultiply (_dt / 2));
        _vel = _newVel;
        _t   = _t + _dt;
    };
    // Out of reach: further passes cannot help
    if (_t >= _timeToLive) exitWith {_tof = _t};
    // Where the rocket crosses the target's range, between the last two steps
    private _prevReach = (_prev vectorDiff _launch) vectorDotProduct _dir;
    private _posReach  = (_pos vectorDiff _launch) vectorDotProduct _dir;
    if (_posReach > _prevReach) then {
        private _frac = ((_reach - _prevReach) / (_posReach - _prevReach)) min 1;
        _pos = _prev vectorAdd ((_pos vectorDiff _prev) vectorMultiply _frac);
        _t   = _t - _dt * (1 - _frac);
    };
    _tof  = _t;
    _miss = _lead vectorDistance _pos;
    _aim  = _aim vectorAdd (_lead vectorDiff _pos);
};

[_launch vectorFromTo _aim, _tof, _aim vectorDiff _target]
