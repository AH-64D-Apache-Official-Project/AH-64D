/* ----------------------------------------------------------------------------
Function: fza_fnc_engineSetPosition

Description:
    Handles the controls for each individual engine

Parameters:
    _heli - The apache helicopter [Unit].
    _engNum - The engine that should be controlled. 0 or 1.
    _position - The control you would like to apply. ENGINE_CONTROL_STARTER, ENGINE_CONTROL_THROTTLE_OFF, ENGINE_CONTROL_THROTTLE_IDLE or ENGINE_CONTROL_THROTTLE_FLY.

Returns:
    Whether the control actually did anything

Examples:
    --- Code
    [_heli, 0, ENGINE_CONTROL_THROTTLE_IDLE] call fza_fnc_engineSetPosition;
    ---

Author:
    mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\engineConstants.h"

params["_heli", "_engNum", "_position"];

if (_heli getVariable "fza_ah64_rtrbrake") exitWith {};

[_heli, 0] call fza_fnc_engineUpdate;
[_heli, 1] call fza_fnc_engineUpdate;

private _otherEngineNum =
    if (_engNum == 0) then {
        1
    } else {
        0
    };
private _heliData = _heli getVariable "fza_ah64_engineStates";
(_heliData# _engNum) params["_state", "_stateParams"];
(_heliData# _otherEngineNum) params["_otherState", "_otherStateParams"];

private _engineSwitch     = format["plt_eng%1_start", _engNum + 1];
private _throttleAnimName = format["plt_eng%1_throttle", _engNum + 1];

private _changeMade = false;

switch (_state) do {
    case "OFF":{
            if (_position == ENGINE_CONTROL_STARTER && !(_otherState in ENGINE_STATE_USING_STARTER) && _heli getVariable "fza_ah64_apu") then {
                _state = "OFFSTARTED";
                _stateParams = time;
                _changeMade = true;

                _heli animateSource[_engineSwitch, 1];
                
                // _heli say3D["fza_ah64_estart_3D", 100, 1];
            };
        };
    case "OFFSTARTED": {
        if (_position == ENGINE_CONTROL_STARTER) then {
            _state = "STARTEDOFF";
            _stateParams = time;
            _changeMade = true;

            _heli animateSource[_engineSwitch, 0];
        };
    }; 
    case "STARTED":{
        if (_position == ENGINE_CONTROL_STARTER) then {
            _state = "STARTEDOFF";
            _stateParams = time;
            _changeMade = true;

            _heli animateSource[_engineSwitch, 0];
        };
        if (_position == ENGINE_CONTROL_THROTTLE_IDLE && _heli getVariable "fza_ah64_apu") then {
            _stateParams = time;
            _state = "STARTEDIDLE";
            _changeMade = true;

            _heli animateSource[_engineSwitch, 0];
            _heli animateSource[_throttleAnimName, 0.25];
        };
    };
    case "IDLE":{
        switch (_position) do {
            case ENGINE_CONTROL_THROTTLE_OFF:{
                    _stateParams = time;
                    _state = "IDLEOFF";
                    _changeMade = true;

                    _heli animateSource[_throttleAnimName, 0];
                };
            case ENGINE_CONTROL_THROTTLE_FLY:{
                    if (_otherState == "IDLE") then {
                        _state = "IDLEFLY";
                        _otherState = "IDLEFLY";
                        _stateParams = time;
                        _otherStateParams = time;
                        _changeMade = true;

                        //0.063 sets the power levers to fly in 16 seconds
                        [_heli, "fza_ah64_powerLever1", 1, 0.063] call fza_fnc_animSetValue;
                        [_heli, "fza_ah64_powerLever2", 1, 0.063] call fza_fnc_animSetValue;
                    }
                };
            };
        };
    case "FLY":{
        if (_position == ENGINE_CONTROL_THROTTLE_IDLE) then {
            _state = "FLYIDLE";
            _otherState = "FLYIDLE";
            _stateParams = time;
            _otherStateParams = time;
            _changeMade = true;
            
            //0.667 sets the power levers to idle in 1.5 seconds
            [_heli, "fza_ah64_powerLever1", 0.25, 0.667] call fza_fnc_animSetValue;
            [_heli, "fza_ah64_powerLever2", 0.25, 0.667] call fza_fnc_animSetValue;
        };
    };
};

if (_changeMade) then {
    if (_engNum == 0) then {
        _heli setVariable["fza_ah64_engineStates", [
            [_state, _stateParams],
            [_otherState, _otherStateParams]
        ], true];
    } else {
        _heli setVariable["fza_ah64_engineStates", [
            [_otherState, _otherStateParams],
            [_state, _stateParams]
        ], true];
    };
}