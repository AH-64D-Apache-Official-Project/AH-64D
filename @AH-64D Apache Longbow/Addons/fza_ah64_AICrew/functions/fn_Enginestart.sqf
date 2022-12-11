/* ----------------------------------------------------------------------------
Function: fza_aiCrew_fnc_engineStart


Description:
    Engine event handler, stops the engines from being turned on using the action menu if they shouldn't be on according to the simulated startup sequence.

Parameters:
	(format of the engine event <https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Engine>)
    heli: Object - The helicopter to modify
    engineState: Boolean - True when the engine is turned on, false when turned off

Returns:
	Nothing

Examples:
	--- Code
    [_heli, true] call fza_aiCrew_fnc_Enginestart;
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_engineState"];

if ((isplayer driver _heli == false) && _engineState == false && (_heli getVariable ["fza_ah64_aiESStop", true] == true)) then {
	_heli setVariable ["fza_ah64_aiESStop", false];
	//Ai Start up sequence
	[_heli, "fza_ah64_rtrbrake", false] call fza_fnc_animSetValue;
	[_heli, "fza_ah64_battery", true] call fza_fnc_animSetValue;
	[_heli, "fza_ah64_apu", true] call fza_fnc_animSetValue;

	sleep 1;
	if (_heli getVariable "fza_ah64_aiESStop") exitwith {[_heli] call fza_aiCrew_fnc_getout};

	_heli setVariable ["fza_sfmplus_engStartSwitchState", 	["START", "OFF"]];
	_heli setVariable ["fza_sfmplus_engState",            	["STARTING", "OFF"]];

	sleep 10;
	if (_heli getVariable "fza_ah64_aiESStop") exitwith {[_heli] call fza_aiCrew_fnc_getout};

	_heli setVariable ["fza_sfmplus_engThrottlePos",  	    ["IDLE", "OFF"]];
	_heli setVariable ["fza_sfmplus_engState",            	["ON", "OFF"]];
	[_heli, "fza_ah64_powerLever1", 0.25, 0.667] call fza_fnc_animSetValue;

	sleep 2;
	if (_heli getVariable "fza_ah64_aiESStop") exitwith {[_heli] call fza_aiCrew_fnc_getout};

	_heli setVariable ["fza_sfmplus_engStartSwitchState", 	["START", "START"]];
	_heli setVariable ["fza_sfmplus_engState",            	["ON", "STARTING"]];

	sleep 10;
	if (_heli getVariable "fza_ah64_aiESStop") exitwith {[_heli] call fza_aiCrew_fnc_getout};

	_heli setVariable ["fza_sfmplus_engThrottlePos",  	["IDLE", "IDLE"]];
	_heli setVariable ["fza_sfmplus_engState",            	["ON", "ON"]];
	[_heli, "fza_ah64_powerLever2", 0.25, 0.667] call fza_fnc_animSetValue;

	sleep 20;
	if (_heli getVariable "fza_ah64_aiESStop") exitwith {[_heli] call fza_aiCrew_fnc_getout};

	[_heli, "fza_ah64_apu", false] call fza_fnc_animSetValue;

	sleep 3;
	if (_heli getVariable "fza_ah64_aiESStop") exitwith {[_heli] call fza_aiCrew_fnc_getout};

	_heli setVariable ["fza_sfmplus_engThrottlePos",  	["FLY", "FLY"]];
	[_heli, "fza_ah64_powerLever1", 1, 0.063] call fza_fnc_animSetValue;
	[_heli, "fza_ah64_powerLever2", 1, 0.063] call fza_fnc_animSetValue;

	_heli setVariable ["fza_ah64_aiESStop", false];
};