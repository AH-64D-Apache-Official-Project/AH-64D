params ["_heli", "_index"];

private _inventory = [_heli] call fza_weapons_fnc_RocketInventory;

if (_inventory # _index isEqualTo []) exitWith {};

private _weapon = getText (configFile >> "CfgAmmo" >> _inventory # _index # 0 >> "fza_weaponName");
_heli setVariable ["fza_ah64_selectedRocket", _weapon, true];
[_heli] call fza_weapons_fnc_UpdateSelected;