/* ----------------------------------------------------------------------------
Function: fza_fnc_engineHandleControl

Description:
    Handles any engine-related cockpit controls.

Parameters:
    _heli - The helicopter to act on
    _system - the name of the system that the touched control belongs to
    _control - the name of the control that has been touched

Returns:
    Nothing

Examples:
    --- Code
    [_heli, "engine", "rtrbrake"] call engineHandleControl
    ---

Author:
    Unknown, mattysmith22, BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\engineConstants.h"
params ["_heli", "_system", "_control"];

private _apuBtnOn     = _heli getVariable "bmkhs_apuBtnOn";
private _battBusOn    = _heli getVariable "bmkhs_battBusOn";

if (player != driver _heli) exitWith {};

switch(_control) do {
    case "apu": {
        if (!_apuBtnOn && _battBusOn) then {
            ["apuBtn", "+1", _heli] call bmkhs_fnc_controlSet;
            playSound "fza_ah64_apubutton";
        } else {
            if (_apuBtnOn) then {
                ["apuBtn", "+1", _heli] call bmkhs_fnc_controlSet;
                //If either of the apache's engines are in a mode where they are using APU, turn it off.
                _heliData = _heli getVariable "fza_ah64_engineStates";
                (_heliData # 0) params ["_e1state"];
                (_heliData # 1) params ["_e2state"];
                if (_e1state in ENGINE_STATE_USING_STARTER) then {
                    [_heli, 0, ENGINE_CONTROL_STARTER] spawn fza_fnc_engineSetPosition;
                };
                if (_e2state in ENGINE_STATE_USING_STARTER) then {
                    [_heli, 1, ENGINE_CONTROL_STARTER] spawn fza_fnc_engineSetPosition;
                };
            };
        };
    };
    case "power": {
        ["battSwitch", "+1", _heli] call bmkhs_fnc_controlSet;
        playSound "fza_ah64_battery";
    };

    //Through the control layer - the brake is a declared HeliSim control, and it drives its
    //own animation. wraps takes the toggle round off -> brake -> lock -> off.
    case "rtrbraketoggle": {
        ["rotorBrake", "+1", _heli] call bmkhs_fnc_controlSet;
    };
    case (localize "STR_FZA_AH64_ROTOR_BRAKE_LOCK"): {
        ["rotorBrake", 2, _heli] call bmkhs_fnc_controlSet;
    };
    case (localize "STR_FZA_AH64_ROTOR_BRAKE_BRAKE"): {
        ["rotorBrake", 1, _heli] call bmkhs_fnc_controlSet;
    };
    case (localize "STR_FZA_AH64_ROTOR_BRAKE_OFF"): {
        ["rotorBrake", 0, _heli] call bmkhs_fnc_controlSet;
    };

    //--------------------ENGINE 1--------------------//
    //Start Switch
    case (localize "STR_FZA_AH64_ENGINE_ONE_START"): {
        ["eng1StartSw", 2, _heli] call bmkhs_fnc_controlSet;
    };
    case (localize "STR_FZA_AH64_ENGINE_ONE_OFF"): {
        ["eng1StartSw", 1, _heli] call bmkhs_fnc_controlSet;
    };
    case (localize "STR_FZA_AH64_ENGINE_ONE_IGN_OVERRIDE"): {
        ["eng1StartSw", 0, _heli] call bmkhs_fnc_controlSet;
    };
    case "e1startertoggle": {
        private _engState = _heli getVariable "bmkhs_engState" select 0;
        if (_engState isEqualTo "OFF") then {
            _heli animateSource ["plt_eng1_start", 1, true];
            ["eng1StartSw", 2, _heli] call bmkhs_fnc_controlSet;
        };
        if (_engState isEqualTo "STARTING") exitWith {
            _heli animateSource ["plt_eng1_start", 0, true];
            ["eng1StartSw", 0, _heli] call bmkhs_fnc_controlSet;
        };
    };
    case "e1off": {
        ["eng1PwrLvr", 0, _heli] call bmkhs_fnc_controlSet;
    };
    case "e1idle": {
        ["eng1PwrLvr", 1, _heli] call bmkhs_fnc_controlSet;
    };
    case "e1fly": {
        private _eng2State       = _heli getVariable "bmkhs_engState" select 1;
        private _eng2PwrLvrState = _heli getVariable "bmkhs_engPowerLeverState" select 1;

        if (_eng2State == "OFF" || (_eng2State == "ON" && _eng2PwrLvrState == "FLY")) then {
            ["eng1PwrLvr", 2, _heli] call bmkhs_fnc_controlSet;
        };

        if (_eng2State == "ON" && _eng2PwrLvrState == "IDLE") then {
            ["eng1PwrLvr", 2, _heli] call bmkhs_fnc_controlSet;
            ["eng2PwrLvr", 2, _heli] call bmkhs_fnc_controlSet;
        };
    };

    //--------------------ENGINE 2--------------------//
    //Start Switch
    case (localize "STR_FZA_AH64_ENGINE_TWO_START"): {
        ["eng2StartSw", 2, _heli] call bmkhs_fnc_controlSet;
    };
    case (localize "STR_FZA_AH64_ENGINE_TWO_OFF"): {
        ["eng2StartSw", 1, _heli] call bmkhs_fnc_controlSet;
    };
    case (localize "STR_FZA_AH64_ENGINE_TWO_IGN_OVERRIDE"): {
        ["eng2StartSw", 0, _heli] call bmkhs_fnc_controlSet;
    };
    case "e2startertoggle": {
        private _engState = _heli getVariable "bmkhs_engState" select 1;
        if (_engState isEqualTo "OFF") then {
            _heli animateSource ["plt_eng2_start", 1, true];
            ["eng2StartSw", 2, _heli] call bmkhs_fnc_controlSet;
        };
        if (_engState isEqualTo "STARTING") exitWith {
            _heli animateSource ["plt_eng2_start", 0, true];
            ["eng2StartSw", 0, _heli] call bmkhs_fnc_controlSet;
        };
    };
    case "e2off": {
        ["eng2PwrLvr", 0, _heli] call bmkhs_fnc_controlSet;
    };
    case "e2idle": {
        ["eng2PwrLvr", 1, _heli] call bmkhs_fnc_controlSet;
    };
    case "e2fly": {
        private _eng1State       = _heli getVariable "bmkhs_engState" select 0;
        private _eng1PwrLvrState = _heli getVariable "bmkhs_engPowerLeverState" select 0;

        if (_eng1State == "OFF" || (_eng1State == "ON" && _eng1PwrLvrState == "FLY")) then {
            ["eng2PwrLvr", 2, _heli] call bmkhs_fnc_controlSet;
        };

        if (_eng1State == "ON" && _eng1PwrLvrState == "IDLE") then {
            ["eng1PwrLvr", 2, _heli] call bmkhs_fnc_controlSet;
            ["eng2PwrLvr", 2, _heli] call bmkhs_fnc_controlSet;
        };
    };
};
