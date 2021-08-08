/* ----------------------------------------------------------------------------
Function: fza_fnc_perfSetMass

Description:
	Sets the initial mass of the helicopter.

Parameters:
	_heli - The apache helicopter to get information from [Unit].

Returns:


Examples:


Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _emptyMass = 0;
if (typeOf _heli == "fza_ah64d_b2e") then {
	_emptyMass = _heli getVariable "fza_sfmplus_emptyMassFCR";
} else {
	_emptyMass = _heli getVariable "fza_sfmplus_emptyMassNonFCR";
};
_heli setVariable["fza_sfmplus_emptyMass", _emptyMass];

private _fwdFuelMass = [_heli] call fza_sfmplus_fnc_fuelSet select 0;
private _aftFuelMass = [_heli] call fza_sfmplus_fnc_fuelSet select 1;

private _pylonMass = 0;
{
	_x params ["_magName","", "_magAmmo"];
	private _magConfig    = configFile >> "cfgMagazines" >> _magName;
	private _magMaxWeight = getNumber (_magConfig >> "weight");
	private _magMaxAmmo   = getNumber (_magConfig >> "count");
	_pylonMass = _pylonMass + linearConversion [0, _magMaxAmmo, _magAmmo, 0, _magMaxWeight];
} foreach magazinesAllTurrets _heli;

private _totalMass = _emptyMass + _fwdFuelMass + _aftFuelMass + _pylonMass;

_heli setMass _totalMass;