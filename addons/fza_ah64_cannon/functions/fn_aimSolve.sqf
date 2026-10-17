/* ----------------------------------------------------------------------------
Function: fza_cannon_fnc_aimSolve

Description:
    The gun direction that puts a round on a point. The round is stepped through
    the engine's own bullet flight - drag of airFriction x speed squared along
    its velocity, and gravity - leaving the muzzle at the magazine's muzzle speed
    plus the aircraft's velocity, and the aim is moved by the miss until it hits.
    Each step moves the round before slowing it, as the engine does; the other
    order aims a few metres high at long range. Steps of 0.05 s stay within 1 m
    of the exact flight to 4.2 km. Starting from the last solution's correction,
    a tracked aim point usually needs one round.
    A moving target is led by its velocity over the round's time of flight.

Parameters:
    _heli      - The helicopter
    _target    - Point to hit (ASL)
    _targetVel - Its velocity (m/s), default still
    _offset    - The last solution's correction (aim point minus target), to start from

Returns:
    [world direction to fire along, time of flight (s), correction for the next solution]

Examples:
    [_heli, _targetASL] call fza_cannon_fnc_aimSolve

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_target", ["_targetVel", [0, 0, 0]], ["_offset", [0, 0, 0]]];

if (isNil "fza_cannon_ballistics") then {
    private _ammo = configFile >> "CfgAmmo" >> "fza_30x113";
    fza_cannon_ballistics = [
        getNumber (configFile >> "CfgMagazines" >> "fza_m230_300" >> "initSpeed"),
        getNumber (_ammo >> "airFriction"),
        [1, getNumber (_ammo >> "coefGravity")] select (isNumber (_ammo >> "coefGravity"))
    ];
};
fza_cannon_ballistics params ["_muzzleSpeed", "_airFriction", "_coefGravity"];

private _dt      = 0.05;
private _gravity = [0, 0, -9.80665 * _coefGravity * _dt];
private _muzzle  = _heli modelToWorldVisualWorld (_heli selectionPosition ["usti hlavne", "Memory"]);
private _heliVel = velocity _heli;
private _aim     = _target vectorAdd _offset;
private _tof     = 0;

private _miss    = 1e9;
for "_i" from 1 to 6 do {
    if (_miss < 0.3) exitWith {};
    // Where a moving target will be when this round arrives
    private _lead  = _target vectorAdd (_targetVel vectorMultiply _tof);
    private _dir   = _muzzle vectorFromTo _aim;
    private _reach = (_lead vectorDiff _muzzle) vectorDotProduct _dir;
    private _pos   = _muzzle;
    private _prev  = _muzzle;
    private _vel   = (_dir vectorMultiply _muzzleSpeed) vectorAdd _heliVel;
    private _t     = 0;
    // 13 s covers the 12.3 s flight to the 4.2 km ballistic range; a point beyond it is never reached
    while {((_pos vectorDiff _muzzle) vectorDotProduct _dir) < _reach && {_t < 13}} do {
        _prev = _pos;
        _pos  = _pos vectorAdd (_vel vectorMultiply _dt);
        _vel  = _vel vectorAdd ((_vel vectorMultiply (_airFriction * vectorMagnitude _vel * _dt)) vectorAdd _gravity);
        _t    = _t + _dt;
    };
    // Where the round crosses the target's range, between the last two steps
    private _prevReach = (_prev vectorDiff _muzzle) vectorDotProduct _dir;
    private _posReach  = (_pos vectorDiff _muzzle) vectorDotProduct _dir;
    if (_posReach > _prevReach) then {
        private _frac = ((_reach - _prevReach) / (_posReach - _prevReach)) min 1;
        _pos = _prev vectorAdd ((_pos vectorDiff _prev) vectorMultiply _frac);
        _t   = _t - _dt * (1 - _frac);
    };
    _tof  = _t;
    _miss = _lead vectorDistance _pos;
    _aim  = _aim vectorAdd (_lead vectorDiff _pos);
};

[_muzzle vectorFromTo _aim, _tof, _aim vectorDiff _target]
