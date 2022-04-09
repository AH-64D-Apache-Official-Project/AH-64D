/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponSelectFireMode

Description:
    Selects the specific weapon AND firemode on a turret.

    May fail in some circumstances (if the firemode doesn't exist), if so will return false and log an error.

Parameters:
    _vehicle - The vehicle to apply this to
    _turret - The turret to work on
    _weapon - The name of the weapon to select - note this can also be done with the muzzle 
    _fireMode - The name of the firemode to select
    
Returns:
	Bool - whether operation succeded

Examples:
    [_heli, [0], "fza_agm114_23_8", "TopDown"] call fza_fnc_weaponSelectFireMode;
Author:
	mattysmith22
---------------------------------------------------------------------------- */
params["_vehicle", "_turret", "_selectedWeapon", "_selectedFireMode"];

if !(_vehicle turretLocal _turret) exitWith {
    ["Cannot switch turret's weapon, turret is not local"] call BIS_fnc_error;
    false;
};

private _crewMember = _vehicle turretUnit _turret;

if (isNull _crewMember) exitWith {
    ["Cannot switch turret's weapon, there must be a crewmember in the seat"] call BIS_fnc_error;
    false;
};

private _cfgWeapons = configFile >> "cfgWeapons";
private _indexes = [];
{
    private _weapon = _x;
    private _weaponConfig = _cfgWeapons >> _x;
    private _muzzles = getArray (_weaponConfig >> "muzzles") apply {if (_x == "this") then {[_weaponConfig, _weapon]} else {[_weaponConfig >> _x, _x]}};
    {
        _x params ["_muzzleConfig", "_muzzle"];
        private _modes = getArray (_muzzleConfig >> "modes") apply {if (_x == "this") then {_muzzle} else {_x}};
        {
            private _mode = _x;
            _indexes pushBack [_weapon, _muzzle, _mode];
        } forEach _modes;
    } forEach _muzzles
} forEach (_vehicle weaponsTurret _turret);

private _index = _indexes findIf {_x # 0 == _selectedWeapon && _x # 2 == _selectedFireMode};


if (_index == -1 ) exitWith {
    ["Cannot switch turret's weapon, couldn't find %1 (searched %2)", [_selectedWeapon, _selectedFireMode]] call BIS_fnc_error;
};

_crewMember action ["SwitchWeapon", _vehicle, _crewMember, _index];
true;