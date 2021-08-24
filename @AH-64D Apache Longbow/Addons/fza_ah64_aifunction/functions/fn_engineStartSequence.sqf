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

//clean reset since heli is meant to be off
vehicle player setVariable ["fza_sfmplus_engStartSwitchState", 	["OFF", "OFF"]]; //OFF, START
vehicle player setVariable ["fza_sfmplus_engPowerLeverState",  	["OFF", "OFF"]]; //OFF, IDLE, FLY
vehicle player setVariable ["fza_sfmplus_engState",            	["OFF", "OFF"]]; //OFF, STARTING, ON
vehicle player animate["plt_eng1_throttle", 0, 10];
vehicle player animate["plt_eng2_throttle", 0, 10];

//Ai Start up sequence
vehicle player animateSource ["plt_rtrbrake", 0];
vehicle player animate["plt_batt", 1, 10];
vehicle player animate["plt_apu", 1];
sleep 1;
vehicle player setVariable ["fza_sfmplus_engStartSwitchState", 	["START", "OFF"]];
vehicle player setVariable ["fza_sfmplus_engState",            	["STARTING", "OFF"]];
Sleep 10;
vehicle player setVariable ["fza_sfmplus_engPowerLeverState",  	["IDLE", "OFF"]];
vehicle player setVariable ["fza_sfmplus_engState",            	["ON", "OFF"]];
vehicle player animate["plt_eng1_throttle", 0.25, 0.667];
sleep 2;
vehicle player setVariable ["fza_sfmplus_engStartSwitchState", 	["START", "START"]];
vehicle player setVariable ["fza_sfmplus_engState",            	["ON", "STARTING"]];
Sleep 10;
vehicle player setVariable ["fza_sfmplus_engPowerLeverState",  	["IDLE", "IDLE"]];
vehicle player setVariable ["fza_sfmplus_engState",            	["ON", "ON"]];
vehicle player animate["plt_eng2_throttle", 0.25, 0.667];
sleep 20;
vehicle player  animate["plt_apu", 0];
sleep 3;
vehicle player setVariable ["fza_sfmplus_engPowerLeverState",  	["FLY", "FLY"]];
vehicle player animate["plt_eng1_throttle", 1, 0.063];
vehicle player animate["plt_eng2_throttle", 1, 0.063];