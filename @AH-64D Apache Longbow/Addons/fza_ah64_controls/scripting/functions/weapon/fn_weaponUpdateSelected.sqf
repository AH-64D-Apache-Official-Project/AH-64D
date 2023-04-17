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

if (player == driver _heli && !isPlayer gunner _heli && !isManualFire _heli) then {
	player action ["ManualFire", vehicle player];
};

switch (_heli getVariable "fza_ah64_was") do {
	case WAS_WEAPON_NONE: {
		_heli selectWeaponTurret ["fza_ma_safe",[0]];
	};
	case WAS_WEAPON_GUN: {
		if (_heli getVariable "fza_ah64_armed") then {
			_heli selectWeaponTurret ["fza_m230",[0]];
		} else {
			_heli selectWeaponTurret ["fza_gun_safe",[0]];
		};
	};
	case WAS_WEAPON_RKT: {
		if (_heli getVariable "fza_ah64_armed") then {
			private _selectedRocket = _heli getVariable "fza_ah64_selectedRocket";
			if (_selectedRocket != "") then {
				_heli selectWeaponTurret [_selectedRocket,[0]];
			} else {
				private _rockets = weapons _heli select {_x isKindOf ["fza_hydra70", configFile >> "CfgWeapons"]};
				if (count _rockets > 0) then {
					_heli setVariable ["fza_ah64_selectedRocket", _rockets # 0, true];
					_heli selectWeaponTurret [_rockets # 0,[0]];
				} else {
					_heli selectWeaponTurret ["fza_ma_safe",[0]];
				};
			};
		} else {
			_heli selectWeaponTurret ["fza_ma_safe",[0]];
		};
	};
	case WAS_WEAPON_MSL: {
		if (_heli getVariable "fza_ah64_armed") then {
			private _selectedMissile = _heli getVariable "fza_ah64_selectedMissile";
			if (_selectedMissile != "") then {
				vehicle player selectWeaponTurret [_selectedMissile,[0],_selectedMissile];
			} else {
				private _missiles = weapons _heli select {_x isKindOf ["fza_hellfire", configFile >> "CfgWeapons"]};
				if (count _missiles > 0) then {
					_heli setVariable ["fza_ah64_selectedMissile", _missiles # 0, true];
					vehicle player selectWeaponTurret [_missiles # 0,[0],_missiles # 0];
				} else {
					_heli selectWeaponTurret ["fza_ma_safe",[0]];
				};
			};
		} else {
			_heli selectWeaponTurret ["fza_ma_safe",[0]];
		};
	};
};