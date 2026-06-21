/* ----------------------------------------------------------------------------
Function: fza_dms_fnc_getNearestFcrTargetData

Description:
    Finds the nearest FCR target row to a world position, with a max distance.

Parameters:
    _heli        - the helicopter
    _positionASL - reference world position (ASL)
    _maxDistance - max match distance in metres [200]

Returns:
    Matching FCR row or [] when no nearby match exists.

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", ["_positionASL", [0, 0, 0]], ["_maxDistance", 200]];

if (_positionASL isEqualTo [0, 0, 0]) exitWith {[]};

private _fcrTargets = _heli getVariable ["fza_ah64_fcrTargets", []];
if (_fcrTargets isEqualTo []) exitWith {[]};

private _closestTarget = ([_fcrTargets, [], {(_x # 0) distance2D _positionASL}, "ASCEND"] call BIS_fnc_sortBy) # 0;
if (((_closestTarget # 0) distance2D _positionASL) > _maxDistance) exitWith {[]};

_closestTarget
