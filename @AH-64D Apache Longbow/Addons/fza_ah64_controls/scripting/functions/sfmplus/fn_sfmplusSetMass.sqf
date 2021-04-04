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
	_emptyMass = _heli getVariable "fza_ah64d_emptyMassFCR";
} else {
	_emptyMass = _heli getVariable "fza_ah64d_emptyMassNonFCR";
};

private _fwdFuelMass = [_heli] call fza_fnc_sfmplusSetFuel select 0;
private _aftFuelMass = [_heli] call fza_fnc_sfmplusSetFuel select 1;

//----------------------------------------Ammo----------------------------------------//
/***
//This needs to include 30mm rounds + hellfires and rockets...

private _pylonMass = 0;

{
	private _magazineClass = (configFile >> "CfgMagazines" >> _x);
	private _ammoClass     = (configFile >> "CfgAmmo" >> getText (_magazineClass >> "ammo"));
	
	private _massFull  = getNumber (_magazineClass >> "mass");
	
	private _countNow  = _heli ammoOnPylon (_forEachIndex + 1);
	private _countFull = 1 max getNumber (_magazineClass >> "count");
	
	private _magazineMass = _massFull * _countNow / _countFull;
	_pylonMass = _pylonMass + _magazineMass;
} foreach (getPylonMagazines _heli);

_heli setVariable ["fza_ah64d_initPylonMass", _pylonMass];
***/

//Set the current gross weight
private _totalMass = _emptyMass + _fwdFuelMass + _aftFuelMass;
//private _rampMass = _emptyMass + _fwdFuelMass + _aftFuelMass + _pylonMass;
_heli setMass _totalMass;