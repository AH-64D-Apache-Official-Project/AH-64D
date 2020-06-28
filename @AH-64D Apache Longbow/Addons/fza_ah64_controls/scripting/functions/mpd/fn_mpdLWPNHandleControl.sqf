#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\selections.h"
params ["_heli", "_system", "_control"];

private _hellfireweps = ["fza_agm114_23_8", "fza_agm114_14_8", "fza_agm114_1_4", "fza_agm114_2_4", "fza_agm114_3_4", "fza_agm114_4_4", "fza_agm114_1_ul", "fza_agm114_1_ur", "fza_agm114_1_ll", "fza_agm114_1_lr", "fza_agm114_2_ul", "fza_agm114_2_ur", "fza_agm114_2_ll", "fza_agm114_2_lr", "fza_agm114_3_ul", "fza_agm114_3_ur", "fza_agm114_3_ll", "fza_agm114_3_lr", "fza_agm114_4_ul", "fza_agm114_4_ur", "fza_agm114_4_ll", "fza_agm114_4_lr"];
private _rocketweps = ["fza_m261_1234_zoneE", "fza_m261_14", "fza_m261_14_zoneA", "fza_m261_14_zoneB", "fza_m261_14_zoneE", "fza_m261_23", "fza_m261_23_zoneC", "fza_m261_23_zoneD", "fza_m261_23_zoneE", "fza_m261_1", "fza_m261_1_zone1", "fza_m261_1_zone2", "fza_m261_1_zone3", "fza_m261_2", "fza_m261_2_zone1", "fza_m261_2_zone2", "fza_m261_2_zone3", "fza_m261_3", "fza_m261_3_zone1", "fza_m261_3_zone2", "fza_m261_3_zone3", "fza_m261_4", "fza_m261_4_zone1", "fza_m261_4_zone2", "fza_m261_4_zone3"];

if(currentWeapon _heli in ["fza_m230", "fza_burstlimiter"]) then {
	switch (_control) do {
		case "l1": {
			fza_ah64_burst_limit = 10;
		};
		case "l2": {
			fza_ah64_burst_limit = 20;
		};
		case "l3": {
			fza_ah64_burst_limit = 50;
		};
		case "l4": {
			fza_ah64_burst_limit = 100;
		};
	};
};
private _rocketweps = ["fza_m261_1234_zoneE", "fza_m261_14", "fza_m261_14_zoneA", "fza_m261_14_zoneB", "fza_m261_14_zoneE", "fza_m261_23", "fza_m261_23_zoneC", "fza_m261_23_zoneD", "fza_m261_23_zoneE", "fza_m261_1", "fza_m261_1_zone1", "fza_m261_1_zone2", "fza_m261_1_zone3", "fza_m261_2", "fza_m261_2_zone1", "fza_m261_2_zone2", "fza_m261_2_zone3", "fza_m261_3", "fza_m261_3_zone1", "fza_m261_3_zone2", "fza_m261_3_zone3", "fza_m261_4", "fza_m261_4_zone1", "fza_m261_4_zone2", "fza_m261_4_zone3"];
if(currentWeapon _heli in _rocketweps) then {
	switch (_control) do {
		case "r1": {
			[_heli] execVM "\fza_ah64_controls\scripting\rocket_salvo.sqf";
		};
	};
};
if(currentweapon _heli in _hellfireweps) then {
	switch (_control) do {
		case "l1": {
			if (fza_ah64_hfmode == _heli) then {
				[_heli] execvm "\fza_ah64_controls\scripting\mode_remt.sqf"
			} else {
				fza_ah64_hfmode = _heli;
			};
		};
		case "r3": {
			[_heli] execvm "\fza_ah64_controls\scripting\ltype_tog.sqf";
		};
	};
};
switch (_control) do {
	case "r6": {
		[_heli] execvm "\fza_ah64_controls\scripting\guncontrol.sqf";
	};
	case "r5": {
		if (_heli hasweapon "Laserdesignator_mounted") then {
			_heli removemagazine "Laserbatteries";
			_heli removeweapon "Laserdesignator_mounted";
		} else {
			[_heli] call fza_fnc_laserArm;;
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
		_emptywep = "";
		_wpncounter = 0;
		_selectedweapon = 0; 
		{
			if (_x in _hellfireweps) then {
				_emptywep = _x;
			};
			if ((_x in _hellfireweps) && _heli ammo _x > 0 && _selectedweapon == 0) then {
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
			if (_x in _rocketweps) then {
				_emptywep = _x;
			};
			if ((_x in _rocketweps) && _heli ammo _x > 0 && _selectedweapon == 0) then {
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
		fza_ah64_pl_mpd = "wpn";
	};
	case "m": {
		fza_ah64_pl_mpd = "dms";
		_heli setobjecttexture [SEL_PL_MPD_BACK, "\fza_ah64_us\tex\dms.paa"];
		if (("fza_ah64_ldp_fail" in (_heli magazinesturret[-1])) && !("fza_ah64_rdp_fail" in (_heli magazinesturret[-1]))) then {
			fza_ah64_pr_mpd = "fail";
			_heli setobjecttexture [SEL_PR_MPD_BACK, ""];
		};
	};
};