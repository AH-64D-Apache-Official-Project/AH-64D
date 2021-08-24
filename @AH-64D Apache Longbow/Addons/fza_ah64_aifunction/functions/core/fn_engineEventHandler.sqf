/* ----------------------------------------------------------------------------
Function: fza_fnc_engineEventHandler

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
    [_heli, true] call fza_fnc_engineEventHandler
	---

Author:
	Unknown, Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_engineState"];

if(local _heli && !(_heli getVariable "fza_ah64_estarted") && _engineState && (isplayer vehicle player == true)) then {
	_heli engineOn false;
};

if (isplayer vehicle player == false && isengineon _heli = false) then {
	vehicle player animateSource ["plt_rtrbrake", 0];
	vehicle player animate["plt_batt", 1];
	vehicle player animate["plt_apu", 1];
	vehicle player setVariable ["fza_sfmplus_engPowerLeverState",["FLY", "FLY"]];
	vehicle player setVariable ["fza_sfmplus_engState",["ON", "ON"]];
	vehicle player setVariable ["fza_ah64_estarted", true, true];
	vehicle player animate["plt_eng1_throttle", 1];
	vehicle player animate["plt_eng2_throttle", 1];
	vehicle player engineon true;
	vehicle player animate["plt_apu", 0];
} else {
	vehicle player animate["plt_eng1_throttle", 0];
	vehicle player animate["plt_eng2_throttle", 0];
	vehicle player setVariable ["fza_ah64_estarted", false, true];
	vehicle player setVariable ["fza_sfmplus_engPowerLeverState",["OFF", "OFF"]];
	vehicle player setVariable ["fza_sfmplus_engState",["OFF", "OFF"]];
	vehicle player animate["plt_apu", 0];
	vehicle player animate["plt_batt", 0];
	vehicle player animateSource ["plt_rtrbrake", 0];
};

_heli setVariable ["fza_sfmplus_engPowerLeverState",  	["OFF", "OFF"]]; //OFF, IDLE, FLY
_heli setVariable ["fza_sfmplus_engState",            	["OFF", "OFF"]]; //OFF, STARTING, ON