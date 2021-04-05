/* ----------------------------------------------------------------------------
Function: fza_fnc_sfmplusConfig

Description:

Parameters:
	_heli - The apache helicopter to get information from [Unit].

Returns:


Examples:


Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

_heli setVariable ["fza_ah64d_emptyMassFCR",    6609]; //kg
_heli setVariable ["fza_ah64d_emptyMassNonFCR", 6314]; //kg

_heli setVariable ["fza_ah64d_stabWidth", 3.22];  //m
_heli setVariable ["fza_ah64d_stabLength", 1.07]; //m

_heli setVariable ["fza_ah64d_maxFwdFuelMass", 473];	//1043lbs in kg
//_heli setVariable ["fza_ah64d_maxCtrFuelMass", 300];	//663lbs in kg, net yet implemented, center robbie
_heli setVariable ["fza_ah64d_maxAftFuelMass", 669]; 	//1474lbs in kg

[_heli] call fza_fnc_sfmplusSetFuel;
[_heli] call fza_fnc_sfmplusSetMass;

