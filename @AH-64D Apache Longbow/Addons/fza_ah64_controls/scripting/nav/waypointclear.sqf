params ["_heli"];

_heli setVariable ["fza_ah64_waypointdata", [_heli getVariable "fza_ah64_waypointdata" select 0], true];

_heli vehiclechat "Waypoints cleared.";