#include "\fza_ah64_controls\headers\selections.h"
params ["_heli", "_system", "_control"];

if(currentWeapon _heli in ["fza_m230", "fza_burstlimiter"]) then {
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
if(currentWeapon _heli isKindOf ["fza_hydra70", configFile >> "CfgWeapons"]) then {
	switch (_control) do {
		case "r1": {
			[_heli] execVM "\fza_ah64_controls\scripting\rocket_salvo.sqf";
		};
	};
};
if(currentWeapon _heli isKindOf ["fza_hellfire", configFile >> "CfgWeapons"]) then {
	switch (_control) do {
		case "l1": {
			//Switch missile lase
			[_heli] call fza_fnc_controlHandlelaserchange;
		};
		case "r3": {
			//Switch missile trajectory of current hellfire
			[_heli] call fza_fnc_weaponTrajectoryChange;
		};
	};
};
switch (_control) do {
	case "r6": {
		[_heli] execvm "\fza_ah64_controls\scripting\guncontrol.sqf";
	};
	case "r5": {
		if (isNull laserTarget _heli) then {
			[_heli] spawn fza_fnc_laserArm;
		} else {
			[_heli] spawn fza_fnc_laserDisarm;
		};
	};
	case "b1": {
		//Select M230
		if (_heli hasweapon "fza_m230") then {
			_heli selectweapon "fza_m230";
		} else {
			_heli selectweapon "fza_burstlimiter";
		};
	};
	case "b2": {
		//Select Missile
		_missileWeps = (_heli weaponsTurret [0]) arrayIntersect _hellfireweps;
		_curIndex = _missileWeps find (currentWeapon _heli);
		_nextWep = _missileWeps select ((_curIndex + 1)% count _missileWeps);
		[_heli, [0], _nextWep, _heli getVariable "fza_ah64_ltype"] call fza_fnc_weaponSelectFireMode;
	};
	case "b3": {
		//Select ATAS
		if (_heli hasweapon "fza_atas_2") then {
			_heli selectweapon "fza_atas_2";
		};
	};
	case "b4": {
		_emptywep = "";
		_wpncounter = 0;
		_selectedweapon = 0; {
			if (_x isKindOf ["fza_hydra70", configFile >> "CfgWeapons"]) then {
				_emptywep = _x;
			};
			if ((_x isKindOf ["fza_hydra70", configFile >> "CfgWeapons"]) && _heli ammo _x > 0 && _selectedweapon == 0) then {
				_selectedweapon = 1;
				_heli selectweapon _x;
			};
			if (_selectedweapon == 1) exitwith {};
			_wpncounter = _wpncounter + 1;
			if (_wpncounter >= count(weapons _heli)) then {
				_selectedweapon = 1;
				_heli selectweapon _emptywep;
			};
		}
		foreach(weapons _heli);
	};
	case "wpn": {
		[_heli, 0, "wpn"] call fza_fnc_mpdSetDisplay;
	};
	case "m": {
		[_heli, 0, "dms"] call fza_fnc_mpdSetDisplay;
	};
};