/* ----------------------------------------------------------------------------
Function: fza_fnc_controlHandleNextWaypoint

Description:
    Moves the to the next waypoint in the helicopter's list

Parameters:
    _heli - the helicopter you would like to change the waypoint of

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_fnc_controlHandleNextWaypoint
	---

Author:
	Unknown
---------------------------------------------------------------------------- */
params["_heli"];

if (_heli getVariable "fza_ah64_curwpnum" < (count (_heli getVariable "fza_ah64_waypointdata") - 1)) then {
    _heli setVariable ["fza_ah64_curwpnum", (_heli getVariable "fza_ah64_curwpnum") + 1, true];
};