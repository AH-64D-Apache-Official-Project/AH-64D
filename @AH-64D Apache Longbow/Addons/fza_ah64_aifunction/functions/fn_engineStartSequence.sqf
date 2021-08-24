/* ----------------------------------------------------------------------------
Function: fza_aifunction_fnc_engineStartSequence


Description:
    Engine event handler, stops the engines from being turned on using the action menu if they shouldn't be on according to the simulated startup sequence.

Parameters:
	(format of the engine event <https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Engine>)
    _heli - The helicopter to modify
    _engineState - True when the engine is turned on, false when turned off

Returns:
	Nothing

Examples:
	--- Code
    [_heli, true] call fza_aifunction_fnc_Enginestarts
	---

Author:
	Unknown, Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

//clean reset since heli is meant to be off
_heli setVariable ["fza_sfmplus_engStartSwitchState", 	["OFF", "OFF"]]; //OFF, START
_heli setVariable ["fza_sfmplus_engPowerLeverState",  	["OFF", "OFF"]]; //OFF, IDLE, FLY
_heli setVariable ["fza_sfmplus_engState",            	["OFF", "OFF"]]; //OFF, STARTING, ON
_heli animate["plt_eng1_throttle", 0, 10];
_heli animate["plt_eng2_throttle", 0, 10];

//Ai Start up sequence
_heli animateSource ["plt_rtrbrake", 0];
_heli animate["plt_batt", 1, 10];
_heli animate["plt_apu", 1];
sleep 1;
_heli setVariable ["fza_sfmplus_engStartSwitchState", 	["START", "OFF"]];
_heli setVariable ["fza_sfmplus_engState",            	["STARTING", "OFF"]];
Sleep 10;
_heli setVariable ["fza_sfmplus_engPowerLeverState",  	["IDLE", "OFF"]];
_heli setVariable ["fza_sfmplus_engState",            	["ON", "OFF"]];
_heli animate["plt_eng1_throttle", 0.25, 0.667];
sleep 2;
_heli setVariable ["fza_sfmplus_engStartSwitchState", 	["START", "START"]];
_heli setVariable ["fza_sfmplus_engState",            	["ON", "STARTING"]];
Sleep 10;
_heli setVariable ["fza_sfmplus_engPowerLeverState",  	["IDLE", "IDLE"]];
_heli setVariable ["fza_sfmplus_engState",            	["ON", "ON"]];
_heli animate["plt_eng2_throttle", 0.25, 0.667];
sleep 20;
_heli  animate["plt_apu", 0];
sleep 3;
_heli setVariable ["fza_sfmplus_engPowerLeverState",  	["FLY", "FLY"]];
_heli animate["plt_eng1_throttle", 1, 0.063];
_heli animate["plt_eng2_throttle", 1, 0.063];