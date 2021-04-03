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

private _fuelMass = [_heli] call fza_fnc_sfmplusSetFuel;
_heli setVariable ["fza_ah64d_initFwdFuelMass", (_fuelMass select 0)];
_heli setVariable ["fza_ah64d_initAftFuelMass", (_fuelMass select 1)];
private _fwdFuelMass = _fuelMass select 0;
private _aftFuelMass = _fuelMass select 1;

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
private _rampMass = _emptyMass + _fwdFuelMass + _aftFuelMass;
_heli setVariable ["fza_ah64d_rampMass", _rampMass];
//private _rampMass = _emptyMass + _fwdFuelMass + _aftFuelMass + _pylonMass;
_heli setMass _rampMass;


/***
vehicle player call fza_fnc_perfConfig;

_emptyMass = 0;

if (typeOf vehicle player == "fza_ah64d_b2e") then { 
	_emptyMass = vehicle player getVariable "fza_ah64d_emptyMassFCR";
} else { 
	_emptyMass = vehicle player getVariable "fza_ah64d_emptyMassNonFCR";
};

_fuelMass = [vehicle player] call fza_fnc_setFuel;
_fwdFuelMass = _fuelMass select 0;
_aftFuelMass = _fuelMass select 1;

_rampMass = _emptyMass + _fwdFuelMass + _aftFuelMass;

vehicle player setMass _rampMass;

hintSilent format ["Empty Mass = %1", _rampMass];

***/