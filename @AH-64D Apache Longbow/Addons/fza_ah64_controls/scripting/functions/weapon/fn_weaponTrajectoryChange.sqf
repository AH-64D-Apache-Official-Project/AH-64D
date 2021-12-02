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

private _nextFireMode = switch (_heli getVariable "fza_ah64_hellfireTrajectory") do {
	case "hi": {"lo"};
	case "lo": {"dir"};
	case "dir": {"hi"};
	default {["Unknown missile fire mode: %1", _fireMode] call BIS_fnc_error};
};
_heli setVariable ["fza_ah64_hellfireTrajectory", _nextFireMode, true];
[_heli] call fza_fnc_weaponUpdateSelected;