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
fza_ah64_curwpnum = fza_ah64_curwpnum - 1;
if (fza_ah64_curwpnum < 0) then {
    fza_ah64_curwpnum = 0;
};