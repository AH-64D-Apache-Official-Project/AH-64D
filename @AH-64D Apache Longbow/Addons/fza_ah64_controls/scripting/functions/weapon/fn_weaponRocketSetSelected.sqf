params ["_heli", "_index"];

if !(heli turretLocal [0]) exitWith {};
private _inventory = [_heli] call fza_fnc_weaponRocketInventory;

if (_inventory # _index isEqualTo []) exitWith {};

private _weapon = getText (configFile >> "CfgAmmo" >> _inventory # _index # 0 >> "fza_weaponName");
_heli setVariable ["fza_ah64_selectedRocket", _weapon, true];
[_heli] call fza_fnc_weaponUpdateSelected;