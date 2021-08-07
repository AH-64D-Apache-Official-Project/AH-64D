/* ----------------------------------------------------------------------------
Function: fza_fnc_sfmplusConfig

Description:


Parameters:
	_heli - The apache helicopter to get information from [Unit].

Returns:
	The mass of the forward and aft fuel cells.

Examples:
	...
	_fuelMass = [_heli] call fza_fnc_setFuel;
	_fwdFuelMass = _fuelMass select 0;
	_aftFuelMass = _fuelMass select 1;

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

_heli setVariable ["fza_ah64_emptyMassFCR",    6609]; //kg
_heli setVariable ["fza_ah64_emptyMassNonFCR", 6314]; //kg

_heli setVariable ["fza_ah64_stabPos", [0.0, -7.207, -0.50]];
_heli setVariable ["fza_ah64_stabWidth", 3.22];  //m
_heli setVariable ["fza_ah64_stabLength", 1.07]; //m

_heli setVariable ["fza_ah64_maxFwdFuelMass", 473];	    //1043lbs in kg
//_heli setVariable ["fza_ah64_maxCtrFuelMass", 300];	//663lbs in kg, net yet implemented, center robbie
_heli setVariable ["fza_ah64_maxAftFuelMass", 669]; 	//1474lbs in kg
//_heli setVariable ["fza_ah64_maxExtFuelMass", 690];     //1541lbs in kg, not yet implemented, 230gal external tank

[_heli] call fza_sfmplus_fnc_fuelSet;
[_heli] call fza_sfmplus_fnc_massSet;

_heli setVariable ["fza_ah64_totRtrDmg",     0];
_heli setVariable ["fza_ah64_dmgTimerCont",  0];
_heli setVariable ["fza_ah64_dmgTimerTrans", 0];
[_heli] call fza_sfmplus_fnc_engineVariables;