/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_coreConfig

Description:
	Defines key values for the simulation.

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

private _config = configFile >> "CfgVehicles" >> typeof _heli >> "Fza_SfmPlus";

_heli setVariable ["fza_sfmplus_emptyMassFCR",    	getNumber (_config >> "emptyMassFCR")]; 	//kg
_heli setVariable ["fza_sfmplus_emptyMassNonFCR", 	getNumber (_config >> "emptyMassNonFCR")]; 	//kg

_heli setVariable ["fza_sfmplus_stabPos", 			getArray  (_config >> "stabPos")];
_heli setVariable ["fza_sfmplus_stabWidth", 		getNumber (_config >> "stabWidth")];  	//m
_heli setVariable ["fza_sfmplus_stabLength", 		getNumber (_config >> "stabLength")]; 	//m

_heli setVariable ["fza_sfmplus_forcePos",			getArray (_config >> "forcePos")];		//m

_heli setVariable ["fza_sfmplus_maxFwdFuelMass", 	getNumber (_config >> "maxFwdFuelMass")];	//1043lbs in kg
_heli setVariable ["fza_sfmplus_maxCtrFuelMass",    getNumber (_config >> "maxCtrFuelMass")];	//663lbs in kg, net yet implemented, center robbie
_heli setVariable ["fza_sfmplus_maxAftFuelMass", 	getNumber (_config >> "maxAftFuelMass")]; 	//1474lbs in kg
//_heli setVariable ["fza_sfmplus_maxExtFuelMass", getNumber (_config >> "maxExtFuelMass")];     //1541lbs in kg, not yet implemented, 230gal external tank

//Fuel and Mass
private _initFuelFrac  = 0.0;
private _IAFSInstalled = _heli getVariable "fza_ah64_IAFSInstalled";
if (_IAFSInstalled) then {
	_initFuelFrac = getNumber (_config >> "initFuelFracRobbie");
} else {
	_initFuelFrac = getNumber (_config >> "initFuelFracNoRobbie");
};
_heli setFuel _initFuelFrac;
[_heli] call fza_sfmplus_fnc_fuelSet;
[_heli] call fza_sfmplus_fnc_massSet;

//Engines
_heli setVariable ["fza_sfmplus_totRtrDmg",     0];
_heli setVariable ["fza_sfmplus_dmgTimerCont",  0];
_heli setVariable ["fza_sfmplus_dmgTimerTrans", 0];
[_heli] call fza_sfmplus_fnc_engineVariables;

//Performance
[_heli] call fza_sfmplus_fnc_perfVariables;