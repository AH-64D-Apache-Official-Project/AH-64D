/* ----------------------------------------------------------------------------
Function: fza_cannon_fnc_rangePoint

Description:
    Where a round fired along the gun's present direction (fza_cannon_gunAim) is
    when it reaches a range from the muzzle: the fixed gun's impact point for that
    range. Stepped through the same bullet flight as fza_cannon_fnc_aimSolve -
    muzzle speed plus the aircraft's velocity, drag, gravity and ACE wind.
    A range beyond the round's 13 s flight gives where it is at the end of it.

Parameters:
    _heli  - The helicopter
    _range - Range from the muzzle (m)

Returns:
    The point (ASL)

Examples:
    [_heli, 1000] call fza_cannon_fnc_rangePoint

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_range"];

if (isNil "fza_cannon_ballistics") then {[_heli, getPosASL _heli] call fza_cannon_fnc_aimSolve};
fza_cannon_ballistics params ["_muzzleSpeed", "_airFriction", "_coefGravity"];

private _dt      = 0.05;
private _wind    = [[0, 0, 0], wind] select ((missionNamespace getVariable ["ace_winddeflection_enabled", false]) && {missionNamespace getVariable ["ace_winddeflection_vehicleEnabled", false]});
private _gravity = [0, 0, -9.80665 * _coefGravity * _dt];
private _muzzle  = _heli modelToWorldVisualWorld (_heli selectionPosition ["usti hlavne", "Memory"]);
(_heli getVariable ["fza_cannon_gunAim", [0, deg 0.298]]) params ["_gunAz", "_gunEl"];
private _dir     = _heli vectorModelToWorldVisual ([1, _gunAz, _gunEl] call CBA_fnc_polar2vect);
private _vel     = (_dir vectorMultiply _muzzleSpeed) vectorAdd velocity _heli;
private _pos     = _muzzle;
private _prev    = _muzzle;
private _t       = 0;

while {(_pos vectorDistance _muzzle) < _range && {_t < 13}} do {
    _prev = _pos;
    _pos  = _pos vectorAdd (_vel vectorMultiply _dt);
    private _air = _vel vectorDiff _wind;
    _vel  = _vel vectorAdd ((_air vectorMultiply (_airFriction * vectorMagnitude _air * _dt)) vectorAdd _gravity);
    _t    = _t + _dt;
};
// Where the round crosses the range, between the last two steps
private _prevDist = _prev vectorDistance _muzzle;
private _posDist  = _pos vectorDistance _muzzle;
if (_t < 13 && {_posDist > _prevDist}) then {
    _pos = _prev vectorAdd ((_pos vectorDiff _prev) vectorMultiply (((_range - _prevDist) / (_posDist - _prevDist)) min 1));
};

_pos
