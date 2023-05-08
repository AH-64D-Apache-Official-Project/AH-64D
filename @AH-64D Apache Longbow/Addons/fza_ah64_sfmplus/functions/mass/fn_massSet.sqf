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
    _pylonMass = _pylonMass + linearConversion [0, _magMaxAmmo, _magAmmo, 0, _magMaxWeight];
} foreach magazinesAllTurrets _heli;

private _totalMass = _emptyMass + _fwdFuelMass + _ctrFuelMass + _aftFuelMass + _pylonMass;

_heli setMass _totalMass;