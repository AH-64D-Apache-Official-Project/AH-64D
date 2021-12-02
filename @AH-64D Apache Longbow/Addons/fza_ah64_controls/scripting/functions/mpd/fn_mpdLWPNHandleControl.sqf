#include "\fza_ah64_controls\headers\selections.h"
#include "\fza_ah64_controls\headers\systemConstants.h"

params ["_heli", "_system", "_control"];

if(_heli getVariable "fza_ah64_wpnPageSelected" == WAS_WEAPON_GUN) then {
	switch (_control) do {
		case "l1": {
			_heli setVariable ["fza_ah64_burst_limit", 10];
		};
		case "l2": {
			_heli setVariable ["fza_ah64_burst_limit", 20];
		};
		case "l3": {
			_heli setVariable ["fza_ah64_burst_limit", 50];
		};
		case "l4": {
			_heli setVariable ["fza_ah64_burst_limit", 100];
		};
	};
};
if(_heli getVariable "fza_ah64_wpnPageSelected" == WAS_WEAPON_RKT) then {
	private _setSelectedRocketType = {
		params ["_heli", "_type"];
		
	};
	switch (_control) do {
		case "l1": {
			[_heli, 0] call fza_fnc_weaponRocketSetSelected;
		};
		case "l2": {
			[_heli, 1] call fza_fnc_weaponRocketSetSelected;
		};
		case "l3": {
			[_heli, 2] call fza_fnc_weaponRocketSetSelected;
		};
		case "l4": {
			[_heli, 3] call fza_fnc_weaponRocketSetSelected;
		};
		case "l5": {
			[_heli, 4] call fza_fnc_weaponRocketSetSelected;
		};
		case "r1": {
			[_heli] call fza_fnc_weaponRocketsalvo;
		};
	};
};
if(_heli getVariable "fza_ah64_wpnPageSelected" == WAS_WEAPON_MSL) then {
	switch (_control) do {
		case "l1": {
			//Switch missile lase
			[_heli] call fza_fnc_laserCycle;
		};
		case "l3": {
			//Switch missile type
			[_heli] call fza_fnc_weaponMissileCycle
		};
		case "r3": {
			//Switch missile trajectory of current hellfire
			[_heli] call fza_fnc_weaponTrajectoryChange;
		};
	};
};
switch (_control) do {
	case "r5": {
		if (isNull laserTarget _heli) then {
			[_heli] spawn fza_fnc_laserArm;
		} else {
			[_heli] spawn fza_fnc_laserDisarm;
		};
	};
	case "b1": {
		if (_heli getVariable "fza_ah64_was" != WAS_WEAPON_NONE) then {
			_heli setVariable ["fza_ah64_wpnPageSelected", WAS_WEAPON_GUN];
		};
	};
	case "b2": {
		if (_heli getVariable "fza_ah64_was" != WAS_WEAPON_NONE) then {
			_heli setVariable ["fza_ah64_wpnPageSelected", WAS_WEAPON_MSL];
		};
	};
	case "b4": {
		if (_heli getVariable "fza_ah64_was" != WAS_WEAPON_NONE) then {
			_heli setVariable ["fza_ah64_wpnPageSelected", WAS_WEAPON_RKT];
		};
	};
	case "wpn": {
		[_heli, 0, "wpn"] call fza_fnc_mpdSetDisplay;
	};
	case "m": {
		[_heli, 0, "dms"] call fza_fnc_mpdSetDisplay;
	};
};