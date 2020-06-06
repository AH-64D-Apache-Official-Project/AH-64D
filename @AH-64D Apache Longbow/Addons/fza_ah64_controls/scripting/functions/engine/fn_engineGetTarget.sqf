/* ----------------------------------------------------------------------------
Function: fza_fnc_engineGetTarget

Description:
	Returns what the RPM the engine should go to, and in what time

Parameters:
	_heli - The apache helicopter to get information from [Unit].
	_engNum - The engine number that data should be retrieved for, 0 or 1.

Returns:
	[Target RPM, Time]

Examples:
    (begin example)
	_target = [_heli, 0] call fza_fnc_engineGetTarget;
	//_target => [21109, 2]
    (end)

Author:
	mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\engineConstants.h"
params["_heli", "_engNum"];

(_heli getVariable "fza_ah64_engineStates")# _engNum params["_state", "_params"];

switch (_state) do {
    case "OFFSTARTED";
    case "STARTEDOFF";
    case "STARTED";
    case "OFF":{
            [RPM_OFF, 2];
        };
    case "STARTEDIDLE":{
            private _elapsedTime = time - _params;
            if (_elapsedTime < ENGINE_STATE_STARTEDIDLE_ROTOR_DELAY) then {
                [RPM_OFF, 2];
            } else {
                [RPM_IDLE, ENGINE_STATE_LEN_STARTEDIDLE - _elapsedTime];
            };
        };
    case "IDLE":{
            [RPM_IDLE, 2];
        };
    case "IDLEOFF":{
            [RPM_OFF, ENGINE_STATE_LEN_IDLEOFF - (time - _params)];
        };
    case "IDLEFLY":{
            [RPM_FLY, ENGINE_STATE_LEN_IDLEFLY - (time - _params)];
        };
    case "FLYIDLE":{
            [RPM_IDLE, ENGINE_STATE_LEN_FLYIDLE - (time - _params)];
        };
    case "FLY":{
            [RPM_FLY, 2];
        };
    default {
        ["Engine governor hit unknown situation, State: %1, Params: %2", _state, _params] call BIS_fnc_error;
        [RPM_FLY, 2];
    };
};