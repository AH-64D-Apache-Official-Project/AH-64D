#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex", "_control", "_state"];

private _selectedWeapon = _state get "selectedWeapon";

if(_selectedWeapon == WAS_WEAPON_GUN) then {
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
		case "l5": {
			_heli setVariable ["fza_ah64_burst_limit", -1];
		};
	};
};
if(_selectedWeapon == WAS_WEAPON_RKT) then {
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
if(_selectedWeapon == WAS_WEAPON_MSL) then {
	switch (_control) do {
		case "l1": {
			//Switch missile lase
			[_heli] call fza_fnc_controlHandlelaserchange;
		};
		case "r1": {
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
	case "t2": {
		[_heli, _mpdIndex, "ase"] call fza_mpd_fnc_setCurrentPage;
	};
	case "r5": {
		if (isNull laserTarget _heli) then {
			[_heli] spawn fza_fnc_laserArm;
		} else {
			[_heli] spawn fza_fnc_laserDisarm;
		};
	};
	case "b2": {
		//Select M230
		if (_heli getVariable "fza_ah64_was" == WAS_WEAPON_NONE) then {
			if(_state get "selectedWeapon" != WAS_WEAPON_GUN) then {
				_state set ["selectedWeapon", WAS_WEAPON_GUN];
			} else {
				_state get ["selectedWeapon", WAS_WEAPON_NONE];
			}
		};
	};
	case "b3": {
		//Select Missile
		if (_heli getVariable "fza_ah64_was" == WAS_WEAPON_NONE) then {
			if(_state get "selectedWeapon" != WAS_WEAPON_MSL) then {
				_state set ["selectedWeapon", WAS_WEAPON_MSL];
			} else {
				_state get ["selectedWeapon", WAS_WEAPON_NONE];
			}
		};
	};
	case "b5": {
		if (_heli getVariable "fza_ah64_was" == WAS_WEAPON_NONE) then {
			if(_state get "selectedWeapon" != WAS_WEAPON_RKT) then {
				_state set ["selectedWeapon", WAS_WEAPON_RKT];
			} else {
				_state get ["selectedWeapon", WAS_WEAPON_NONE];
			}
		};
	};
	case "b1": {
		[_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
	};
};