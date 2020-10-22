_heli = _this select 0;
_position = _this select 1;

_markerstringc = format["%1", count (_heli getVariable "fza_ah64_waypointdata")];
_markerstring = "fza_ah64_markstring" + _markerstringc;

if (count (_heli getVariable "fza_ah64_waypointdata") > 30) exitwith {
    _heli vehiclechat "Waypoint limits reached.";
};

_heli setVariable ["fza_ah64_waypointdata", (_heli getVariable "fza_ah64_waypointdata") + [[(_position select 0), (_position select 1), 0]], true];