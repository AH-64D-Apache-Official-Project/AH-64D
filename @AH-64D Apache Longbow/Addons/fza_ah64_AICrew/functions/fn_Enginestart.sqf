/* ----------------------------------------------------------------------------
Function: fza_AICrew_fnc_engineStart


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
    [_heli, true] call fza_AICrew_fnc_Enginestarts
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_engineState"];

/*
if(!(_heli getVariable "fza_ah64_estarted") && _engineState) then {
	_heli engineOn false;
};*/

if ((isplayer driver _heli == false) && _engineState == false && (_heli getVariable ["fza_ah64_aiESStop", true] == true)) then {
	_heli setVariable ["fza_ah64_aiESStop", false];
	//Ai Start up sequence
	_heli animateSource ["plt_rtrbrake", 0];
	_heli animate["plt_batt", 1];
	_heli animate["plt_apu", 1];

	sleep 1;
	if (_heli getVariable "fza_ah64_aiESStop") exitwith {[_heli] call fza_AICrew_fnc_getout};

	_heli setVariable ["fza_sfmplus_engStartSwitchState", 	["START", "OFF"]];
	_heli setVariable ["fza_sfmplus_engState",            	["STARTING", "OFF"]];

	sleep 10;
	if (_heli getVariable "fza_ah64_aiESStop") exitwith {[_heli] call fza_AICrew_fnc_getout};

	_heli setVariable ["fza_sfmplus_engPowerLeverState",  	["IDLE", "OFF"]];
	_heli setVariable ["fza_sfmplus_engState",            	["ON", "OFF"]];
	_heli animate["plt_eng1_throttle", 0.25, 0.667];

	sleep 2;
	if (_heli getVariable "fza_ah64_aiESStop") exitwith {[_heli] call fza_AICrew_fnc_getout};

	_heli setVariable ["fza_sfmplus_engStartSwitchState", 	["START", "START"]];
	_heli setVariable ["fza_sfmplus_engState",            	["ON", "STARTING"]];

	sleep 10;
	if (_heli getVariable "fza_ah64_aiESStop") exitwith {[_heli] call fza_AICrew_fnc_getout};

	_heli setVariable ["fza_sfmplus_engPowerLeverState",  	["IDLE", "IDLE"]];
	_heli setVariable ["fza_sfmplus_engState",            	["ON", "ON"]];
	_heli animate["plt_eng2_throttle", 0.25, 0.667];

	sleep 20;
	if (_heli getVariable "fza_ah64_aiESStop") exitwith {[_heli] call fza_AICrew_fnc_getout};

	_heli  animate["plt_apu", 0];

	sleep 3;
	if (_heli getVariable "fza_ah64_aiESStop") exitwith {[_heli] call fza_AICrew_fnc_getout};

	_heli setVariable ["fza_sfmplus_engPowerLeverState",  	["FLY", "FLY"]];
	_heli animate["plt_eng1_throttle", 1, 0.063];
	_heli animate["plt_eng2_throttle", 1, 0.063];

	_heli setVariable ["fza_ah64_aiESStop", false];
};