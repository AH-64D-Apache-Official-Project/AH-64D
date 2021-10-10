fza_mapclickchk = param [0, objNull];

if (isNull fza_mapclickchk) exitWith {};

fza_ah64_waypointfin = 0;

fza_mapclickchk vehicleChat "Waypoint configuration activated.";

private _clickID = addMissionEventHandler ["MapSingleClick", 
{
	params ["", "_pos"];
    [fza_mapclickchk, _pos] execvm "\fza_ah64_controls\scripting\nav\wp_position.sqf";
}];

waituntil {fza_ah64_waypointfin isEqualTo 1 || !alive fza_mapclickchk};

removeMissionEventHandler ["MapSingleClick", _clickID];

fza_mapclickchk vehicleChat "Waypoints saved.";
