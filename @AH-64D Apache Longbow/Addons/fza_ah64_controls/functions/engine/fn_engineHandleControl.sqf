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
#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\engineConstants.h"
params ["_heli", "_system", "_control"];

private _apuBtnOn     = _heli getVariable "fza_systems_apuBtnOn";
private _battSwitchOn = _heli getVariable "fza_systems_battSwitchOn";
private _battBusOn    = _heli getVariable "fza_systems_battBusOn";

switch(_control) do {
    case "apu": {
        if (!_apuBtnOn && _battBusOn) then {
            [_heli] call fza_systems_fnc_interactAPUButton;
            playsound "fza_ah64_apubutton";
            [_heli] spawn fza_fnc_fxLoops;
            [_heli, ["fza_ah64_apustart_3D", 200]] remoteExec["say3d"];
        } else {
            if (_apuBtnOn) then {
                [_heli] call fza_systems_fnc_interactAPUButton;
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
                [_heli, ["fza_ah64_apustop_3D", 100]] remoteExec["say3d"];
            };
        };
    };
    case "power": {
        if (_battSwitchOn) then {
            [_heli] call fza_systems_fnc_interactBattSwitch;
            [_heli] spawn fza_fnc_fxLoops;
            playsound "fza_ah64_battery";
        } else {
            [_heli] call fza_systems_fnc_interactBattSwitch;
            [_heli, ["fza_ah64_fake_3D", 10]] remoteExec["say3d"];
            playsound "fza_ah64_battery";
        };
    };
    
    case "rtrbrake": {
        [_heli, "fza_ah64_rtrbrake", !(_heli getVariable "fza_ah64_rtrbrake")] call fza_fnc_animSetValue;
        playsound "fza_ah64_switch_flip2";
    };

    //--------------------ENGINE 1--------------------//
    //Start Switch
    case "e1start": {
        private _eng1state = _heli getVariable "fza_sfmplus_engstate" select 0;
        [_heli, 0] call fza_sfmplus_fnc_interactStartSwitch;
        [_heli,_eng1state] spawn {
            params ["_heli","_eng1state"];
            if (_eng1state == "OFF") then {
                _heli animateSource ["plt_eng1_start", 1];
                sleep 0.15;
                _heli animateSource ["plt_eng1_start", 0];
                playsound "fza_ah64_switch_flip4";
            };
            if (_eng1state == "STARTING") then {
                _heli animateSource ["plt_eng1_start", -1];
                sleep 0.15;
                _heli animateSource ["plt_eng1_start", 0];
                playsound "fza_ah64_switch_flip4";
            };
        };
    };
    //Power Lever
    case "e1off": {
        [_heli, 0, "OFF"] spawn fza_sfmplus_fnc_interactPowerLever;

        playsound "fza_ah64_throttle_idle";
    };
    case "e1idle": {
        [_heli, 0, "IDLE"] spawn fza_sfmplus_fnc_interactPowerLever;

        playsound "fza_ah64_throttle_idle";
    };
    case "e1fly": {
        private _eng2State       = _heli getVariable "fza_sfmplus_engState" select 1;
        private _eng2PwrLvrState = _heli getVariable "fza_sfmplus_engPowerLeverState" select 1;
        //Allow the eng 1 power lever to be advanced individually when the opposite engine
        //is off OR when the opposite engine is on w/ it's power lever at fly
        if (_eng2State == "OFF" || (_eng2State == "ON" && _eng2PwrLvrState == "FLY")) then {
            [_heli, 0, "FLY"] spawn fza_sfmplus_fnc_interactPowerLever;
        };
        //Advance both power levers to fly together when the opposite engine is on and its
        //power lever is at idle
        if (_eng2State == "ON" && _eng2PwrLvrState == "IDLE") then {
            [_heli, 0, "FLY"] spawn fza_sfmplus_fnc_interactPowerLever;
            [_heli, 1, "FLY"] spawn fza_sfmplus_fnc_interactPowerLever;
        };
        
        playsound "fza_ah64_fake_3D";
    };
    
    //--------------------ENGINE 2--------------------//
    //Start Switch
    case "e2start": {
        private _eng2state = _heli getVariable "fza_sfmplus_engstate" select 1;
        [_heli, 1] call fza_sfmplus_fnc_interactStartSwitch;
        [_heli,_eng2state] spawn {
            params ["_heli","_eng2state"];
            if (_eng2state == "OFF") then {
                _heli animateSource ["plt_eng2_start", 1];
                sleep 0.15;
                _heli animateSource ["plt_eng2_start", 0];
                playsound "fza_ah64_switch_flip4";
            };
            if (_eng2state == "STARTING") then {
                _heli animateSource ["plt_eng2_start", -1];
                sleep 0.15;
                _heli animateSource ["plt_eng2_start", 0];
                playsound "fza_ah64_switch_flip4";
            };
        };
    };
    //Power Lever
    case "e2off": {
        [_heli, 1, "OFF"] spawn fza_sfmplus_fnc_interactPowerLever;

        playsound "fza_ah64_throttle_idle";
    };
    case "e2idle": {
        [_heli, 1, "IDLE"] spawn fza_sfmplus_fnc_interactPowerLever;

        playsound "fza_ah64_throttle_idle";
    };
    case "e2fly": {
        private _eng1State       = _heli getVariable "fza_sfmplus_engState" select 0;
        private _eng1PwrLvrState = _heli getVariable "fza_sfmplus_engPowerLeverState" select 0;
        //Allow the eng 1 power lever to be advanced individually when the opposite engine
        //is off OR when the opposite engine is on w/ it's power lever at fly
        if (_eng1State == "OFF" || (_eng1State == "ON" && _eng1PwrLvrState == "FLY")) then {
            [_heli, 1, "FLY"] spawn fza_sfmplus_fnc_interactPowerLever;
        };
        //Advance both power levers to fly together when the opposite engine is on and its
        //power lever is at idle
        if (_eng1State == "ON" && _eng1PwrLvrState == "IDLE") then {
            [_heli, 0, "FLY"] spawn fza_sfmplus_fnc_interactPowerLever;
            [_heli, 1, "FLY"] spawn fza_sfmplus_fnc_interactPowerLever;
        };
        
        playsound "fza_ah64_fake_3D";
    };
};
