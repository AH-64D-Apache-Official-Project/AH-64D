/* ----------------------------------------------------------------------------
Function: fza_fnc_engineUpdate

Description:
    Updates the state to the correct values.

    You do not need to call manually, is internally used by other functions in this zone.

Parameters:
    _heli - The apache helicopter [Unit].
    _engNum - The engine that should be updated. 0 or 1.

Returns:
    Nothing

Examples:
    You shouldn't need one

Author:
    mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\engineConstants.h"
params["_heli", "_engNum"];

if (!local _heli) exitWith {};

((_heli getVariable "fza_ah64_engineStates") select _engNum) params["_state", "_stateParams"];

private _changeMade = false;
private _nextState = _state;
switch (_state) do {
    case "OFFSTARTED":{
            if (time - _stateParams > ENGINE_STATE_LEN_OFFSTARTED) then {
                _nextState = "STARTED";
                _changeMade = true;
            }
        };
    case "STARTEDOFF":{
            if (time - _stateParams > ENGINE_STATE_LEN_STARTEDOFF) then {
                _nextState = "OFF";
                _changeMade = true;
            }
        };
    case "STARTEDIDLE":{
            if (time - _stateParams > ENGINE_STATE_LEN_STARTEDIDLE) then {
                _nextState = "IDLE";
                _changeMade = true;
            };
        };
    case "IDLEOFF":{
            if (time - _stateParams > ENGINE_STATE_LEN_IDLEOFF) then {
                _nextState = "OFF";
                _changeMade = true;
            };
        };
    case "IDLEFLY":{
            if (time - _stateParams > ENGINE_STATE_LEN_IDLEFLY) then {
                _nextState = "FLY";
                _changeMade = true;
            };
        };
    case "FLYIDLE":{
            if (time - _stateParams > ENGINE_STATE_LEN_FLYIDLE) then {
                _nextState = "IDLE";
                _changeMade = true;
            };
        };
};

if (_changeMade) then {
    _newVal = (_heli getVariable "fza_ah64_engineStates");
    (_newVal# _engNum) set[0, _nextState];
    [_heli, "fza_ah64_engineStates", _newVal] call fza_fnc_updateNetworkGlobal;
};