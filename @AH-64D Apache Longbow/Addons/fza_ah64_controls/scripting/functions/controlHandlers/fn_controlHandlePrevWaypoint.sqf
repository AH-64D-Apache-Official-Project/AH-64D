/* ----------------------------------------------------------------------------
Function: fza_fnc_controlHandlePrevWaypoint

Description:
    Moves the to the previous waypoint in the helicopter's list

Parameters:
    _heli - the helicopter you would like to change the waypoint of

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_fnc_controlHandlePrevWaypoint
	---

Author:
	Unknown
---------------------------------------------------------------------------- */
params["_heli"];
if((_heli getVariable "fza_ah64_curwpnum") > 0) then {
    _heli setVariable ["fza_ah64_curwpnum", (_heli getVariable "fza_ah64_curwpnum") - 1, true];
}