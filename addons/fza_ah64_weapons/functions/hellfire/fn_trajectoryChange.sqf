/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_TrajectoryChange

Description:
    Cycles through the available Hellfire flight trajectories: LO, DIR, HI.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Author:
    Unknown
---------------------------------------------------------------------------- */
params ["_heli"];

private _nextFireMode = [["LO", "DIR", "HI"], _heli getVariable "fza_ah64_hellfireTrajectory"] call fza_fnc_cycle;

_heli setVariable ["fza_ah64_hellfireTrajectory", _nextFireMode, true];
