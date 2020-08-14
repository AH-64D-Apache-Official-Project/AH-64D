#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\selections.h"
params ["_heli", "_system", "_control"];

if(fza_ah64_tsdmode == "NAV") then {
	switch (_control) do {
		case "l1": {
			[_heli] execvm "\fza_ah64_controls\scripting\nav\waypointadd.sqf";
		};
		case "l2": {
			[_heli] execvm "\fza_ah64_controls\scripting\nav\waypointclear.sqf";
		};
		case "l3": {
			[_heli] execvm "\fza_ah64_controls\scripting\nav\waypointsave.sqf";
		};
		case "l6": {
			[_heli] call fza_fnc_controlHandleNextWaypoint;
		};
		case "b1": {
			fza_ah64_tsdmode = "ATK";
		};
		case "b4": {
			//RMPD B4 BTN RTE
			if (count waypoints group(driver _heli) > 1) then {
				fza_ah64_waypointdata = [];
				fza_ah64_waypointdata = fza_ah64_waypointdata + [position _heli]; {
					if (_x select 1 > 0) then {
						fza_ah64_waypointdata = fza_ah64_waypointdata + [waypointPosition _x];
					};
				}
				foreach(waypoints group(driver _heli));
			};
		};
	};
};
if(fza_ah64_tsdmode == "ATK") then {
	switch (_control) do {
		case "l1": {
			[_heli, fza_ah64_pfz_count] execvm "\fza_ah64_controls\scripting\pfz.sqf";
		};
		case "l3": {
			[_heli] execvm "\fza_ah64_controls\scripting\targxfer.sqf";
		};
		case "l4": {
			[_heli] execvm "\fza_ah64_controls\scripting\targrecv.sqf";
		};
		case "b1": {
			fza_ah64_tsdmode = "NAV";
		};
	};
};
switch (_control) do {
	case "l5": {
		[_heli] call fza_fnc_targetingPFZCycle;
	};
	case "b3": {
		[_heli] execvm "\fza_ah64_controls\scripting\tsd_map_toggle.sqf";
	};
	case "r1": {
		[_heli, "OUT"] call fza_fnc_mpdHandleZoom;
	};
	case "r2": {
		[_heli, "IN"] call fza_fnc_mpdHandleZoom;
	};
	case "r3": {
		[_heli] exec "\fza_ah64_controls\scripting\tsd_targfilter.sqs";
	};
	case "t2": {
		[_heli, 1, "ase"] call fza_ah64_mpdSetDisplay;
	};
	case "fcr": {
		[_heli, 1, "fcr"] call fza_ah64_mpdSetDisplay;
	};
	case "m": {
		[_heli, 1, "dms"] call fza_ah64_mpdSetDisplay;
	};
};
