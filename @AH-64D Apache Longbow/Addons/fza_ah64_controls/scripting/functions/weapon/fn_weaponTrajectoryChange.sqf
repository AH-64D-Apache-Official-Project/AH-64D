/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponTrajectoryChange

Description:
    Cycles through the available hellfire trajectories

Parameters:
    _heli - the helicopter

Returns:
    Nothing

Examples:
    [_heli] call fza_fnc_weaponTrajectoryChange

Author:
    Unknown
---------------------------------------------------------------------------- */
params ["_heli"];

private _nextFireMode = [["LO","DIR","HI"], _heli getVariable "fza_ah64_hellfireTrajectory"] call fza_util_fnc_cycle;

_heli setVariable ["fza_ah64_hellfireTrajectory", _nextFireMode, true];