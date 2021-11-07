/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponUpdateSelected

Description:
    Sets the current selected weapon on the gunner's turret to match the settings the mod specifies

Parameters:
    _heli - The helicopter to update

Returns:

Examples:
	statement="[_heli] fza_fnc_weaponUpdateSelected

Author:
	
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params["_heli"];

if !(_heli turretLocal [0]) exitWith {};


if (_heli getVariable "fza_ah64_armed") then {
	player action ["ManualFire", _heli];
} else {
	player action ["ManualFireCancel", _heli];
};
switch (_heli getVariable "fza_ah64_was") do {
	case WAS_WEAPON_NONE: {
		_heli selectWeapon "fza_ma_safe";
	};
	case WAS_WEAPON_GUN: {
		if (_heli getVariable "fza_ah64_armed") then {
			_heli selectWeapon "fza_m230";
		} else {
			_heli selectWeapon "fza_gun_safe";
		};
	};
	case WAS_WEAPON_RKT: {
		if (_heli getVariable "fza_ah64_armed") then {
			private _selectedRocket = _heli getVariable "fza_ah64_selectedRocket";
			if (_selectedRocket != "") then {
				_heli selectWeapon _selectedRocket;
			} else {
				private _rockets = weapons _heli select {_x isKindOf ["fza_hydra70", configFile >> "CfgWeapons"]};
				if (count _rockets > 0) then {
					_heli setVariable ["fza_ah64_selectedRocket", _rockets # 0, true];
					_heli selectWeapon _rockets # 0;
				} else {
					_heli selectWeapon "fza_rkt_safe";
				};
			};
		} else {
			_heli selectWeapon "fza_rkt_safe";
		};
	};
	case WAS_WEAPON_MSL: {
		if (_heli getVariable "fza_ah64_armed") then {
			private _trajectory = switch (_heli getVariable "fza_ah64_hellfireTrajectory") do {
				case "lo": {"TopDown"};
				case "dir": {"LoalDistance"};
				case "hi": {"Cruise"};
				default {""};
			};
			private _selectedMissile = _heli getVariable "fza_ah64_selectedMissile";
			if (_selectedMissile != "") then {
				[_heli, [0], _selectedMissile, _trajectory] call fza_fnc_weaponSelectFireMode;
			} else {
				private _missiles = weapons _heli select {_x isKindOf ["fza_hellfire", configFile >> "CfgWeapons"]};
				if (count _missiles > 0) then {
					_heli setVariable ["fza_ah64_selectedMissile", _missiles # 0, true];
					[_heli, [0], _missiles # 0, _trajectory] call fza_fnc_weaponSelectFireMode;
				} else {
					_heli selectWeapon "fza_msl_safe";
				};
			};
		} else {
			_heli selectWeapon  "fza_msl_safe";
		};
	}
}