/* ----------------------------------------------------------------------------
Function: fza_AICrew_fnc_getout


Description:
	Handles shutdown of SFM+ when AI pilot Gets out

Parameters:
	Heli - The helicopter to modify

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_AICrew_fnc_getout
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if (isplayer driver _heli == false) then {
	//Ai variables
	_heli setVariable ["fza_ah64_aiESStop", true];

	_heli setVariable ["fza_sfmplus_engStartSwihState", 	["OFF", "OFF"]];
	_heli setVariable ["fza_sfmplus_engState",            	["OFF", "OFF"]];
	_heli setVariable ["fza_sfmplus_engPowerLeverState",  	["OFF", "OFF"]];
	_heli animate["plt_eng1_throttle", 0, 10];
	_heli animate["plt_eng2_throttle", 0, 10];
	_heli animate["plt_apu", 0];
	_heli animate["plt_batt", 0];
	_heli animateSource ["plt_rtrbrake", 1];
};