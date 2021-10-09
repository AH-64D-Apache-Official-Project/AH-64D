fza_mapclickchk = param [0, objNull];
fza_ah64_waypointfin = 0;

/* if (!(isNil "fza_ah64_waypointfin") && "fza_ah64_waypointfin"
    isEqualTo 0) exitwith {
    _heli vehiclechat "Waypoint configuration already active.";
}; */

fza_mapclickchk vehicleChat "Waypoint configuration activated.";

private _clickID = addMissionEventHandler ["MapSingleClick", 
{
	params ["", "_pos"];
    [fza_mapclickchk, _pos] execvm "\fza_ah64_controls\scripting\nav\wp_position.sqf";
}];

waituntil {fza_ah64_waypointfin isEqualTo 1 || !alive fza_mapclickchk};

removeMissionEventHandler [MapSingleClick, _clickID];

fza_mapclickchk vehicleChat "Waypoints saved.";
