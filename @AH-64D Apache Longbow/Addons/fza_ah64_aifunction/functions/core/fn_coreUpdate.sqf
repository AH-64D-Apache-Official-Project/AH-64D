/* ----------------------------------------------------------------------------
Function: fza_aifunction_fnc_coreAiUpdate

Description:
	Updates all of the modules core functions.
	
Parameters:
	_heli - The helicopter to get information from [Unit].

Returns:
	...

Examples:
	...

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

vehicle player animateSource ["plt_rtrbrake", 0];
vehicle player animate["plt_batt", 1];
vehicle player animate["plt_apu", 1];
vehicle player setVariable ["fza_sfmplus_engStartSwitchState",["OFF", "OFF"]];
vehicle player setVariable ["fza_sfmplus_engPowerLeverState",["FLY", "FLY"]];
vehicle player setVariable ["fza_sfmplus_engState",["ON", "ON"]];
vehicle player setVariable ["fza_ah64_estarted", true, true];
vehicle player animate["plt_eng1_throttle", 1];
vehicle player animate["plt_eng2_throttle", 1];
vehicle player engineon true;
vehicle player animate["plt_apu", 0];