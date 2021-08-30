/* ----------------------------------------------------------------------------
Function: fza_AICrew_fnc_getout


Description:
	Handles shutdown of SFM+ when AI pilot Gets out

Parameters:
	heli: Object - Vehicle the event handler is assigned to
	role: String - Can be either "driver", "gunner" or "cargo"
	unit: Object - Unit that left the vehicle
	turret: Array - turret path

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_AICrew_fnc_getout
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_role", "_unit", "_turret"];

if (isplayer _unit) exitWith {};

if (_unit == driver _heli) then {
	//Ai variables
	_heli setVariable ["fza_ah64_aiESStop", true];

	//engine
	_heli setVariable ["fza_sfmplus_engStartSwihState", 	["OFF", "OFF"]];
	_heli setVariable ["fza_sfmplus_engState",            	["OFF", "OFF"]];
	_heli setVariable ["fza_sfmplus_engPowerLeverState",  	["OFF", "OFF"]];
	_heli animate["plt_eng1_throttle", 0, 10];
	_heli animate["plt_eng2_throttle", 0, 10];
	_heli animate["plt_apu", 0];
	_heli animate["plt_batt", 0];
	_heli animateSource ["plt_rtrbrake", 1];
};