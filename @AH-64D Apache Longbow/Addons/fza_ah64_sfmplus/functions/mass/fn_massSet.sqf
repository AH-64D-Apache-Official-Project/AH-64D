/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_massSet

Description:
    Sets the initial mass of the helicopter.

Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _emptyMass = 0; 
if (_heli animationPhase "fcr_enable" == 1) then {
    _emptyMass = _heli getVariable "fza_sfmplus_emptyMassFCR";
} else {
    _emptyMass = _heli getVariable "fza_sfmplus_emptyMassNonFCR";
};
_heli setVariable["fza_sfmplus_emptyMass", _emptyMass];

private _fwdFuelMass = [_heli] call fza_sfmplus_fnc_fuelSet select 0;
private _ctrFuelMass = [_heli] call fza_sfmplus_fnc_fuelSet select 1;
private _aftFuelMass = [_heli] call fza_sfmplus_fnc_fuelSet select 2;

private _pylonMass = 0;
{
    _x params ["_magName","", "_magAmmo"];
    private _magConfig    = configFile >> "cfgMagazines" >> _magName;
    private _magMaxWeight = getNumber (_magConfig >> "weight");
    private _magMaxAmmo   = getNumber (_magConfig >> "count");
    _pylonMass            = _pylonMass + linearConversion [0, _magMaxAmmo, _magAmmo, 0, _magMaxWeight];
} foreach magazinesAllTurrets _heli;

private _totalMass = _emptyMass + _fwdFuelMass + _ctrFuelMass + _aftFuelMass + _pylonMass;


private _pylonMagazines = getPylonMagazines _heli;

//Station 1
private _station1mass = 0.0;
for "_i" from 1 to 4 do {
    _magName              = _pylonMagazines select _i;
    _magAmmo              = _heli ammoOnPylon format["pylons%1",_i];
    private _magConfig    = configFile >> "cfgMagazines" >> _magName;
    private _magMaxWeight = getNumber (_magConfig >> "weight");
    private _magMaxAmmo   = getNumber (_magConfig >> "count");
    _station1Mass         = _station1Mass + linearConversion [0, _magMaxAmmo, _magAmmo, 0, _magMaxWeight];
};

//Station 2
private _station2mass = 0.0;
for "_i" from 5 to 8 do {
    _magName              = _pylonMagazines select _i;
    _magAmmo              = _heli ammoOnPylon format["pylons%1",_i];
    private _magConfig    = configFile >> "cfgMagazines" >> _magName;
    private _magMaxWeight = getNumber (_magConfig >> "weight");
    private _magMaxAmmo   = getNumber (_magConfig >> "count");
    _station2Mass         = _station2Mass + linearConversion [0, _magMaxAmmo, _magAmmo, 0, _magMaxWeight];
};

systemChat format["Station 1 Mass = %1 -- Station 2 Mass = %2", _station1Mass, _station2Mass];

//Ammo Magazine
//Station 1 = Pylons 1 thru 4
//Station 2 = Pylons 5 thru 8
//Station 3 = Pylons 9 thru 12
//Station 4 = Pylons 13 thru 16

_heli setMass _totalMass;