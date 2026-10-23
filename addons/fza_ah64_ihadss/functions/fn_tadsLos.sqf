/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_tadsLos

Description:
    The TADS's position and line of sight in model space, from its memory points
    as the turret has them, the same as its render targets: they follow the
    turret smoothly on every machine, where the TADS azimuth and elevation
    variables only reach the other crew station ten times a second.

Parameters:
    _heli - The helicopter

Returns:
    [position, unit direction], model space

Examples:
    --- Code
    ([_heli] call fza_ihadss_fnc_tadsLos) params ["_pos", "_dir"];
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _pos = _heli selectionPosition "laserEnd";
private _dir = vectorNormalized ((_heli selectionPosition "laserBegin") vectorDiff _pos);
// laserBegin is the TADS turret's gunBeg, ahead of laserEnd; checked against the TADS angles all the same, and taken from
// them with the points missing
private _approx = [1, _heli getVariable ["fza_ah64_tadsAzimuth", 0], _heli getVariable ["fza_ah64_tadsElevation", 0]] call CBA_fnc_polar2vect;
if (_dir vectorDotProduct _approx < 0) then {_dir = _dir vectorMultiply -1};
if (_dir isEqualTo [0, 0, 0]) then {_dir = _approx};
[_pos, _dir]
