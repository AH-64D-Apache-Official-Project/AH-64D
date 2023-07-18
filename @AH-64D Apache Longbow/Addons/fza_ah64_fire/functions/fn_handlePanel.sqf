/* ----------------------------------------------------------------------------
Function: fza_fire_fnc_handlePanel

Description:
    Arms or disarms the fire panel

Parameters:
    heli - The helicopter to act on   
    engine- the engine selected 

Returns:

Examples:
    [_heli] call fza_fnc_firepanel
    
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli","_engine","_value"];

private _battBusOn          = _heli getVariable "fza_systems_battBusOn";
private _crewStation        = _heli call fza_fnc_currentTurret;
private _engineOneArm       = (_heli getVariable "fza_ah64_fireArmed1") # 1;
private _engineTwoArm       = (_heli getVariable "fza_ah64_fireArmed2") # 1;
private _engineApuArm       = (_heli getVariable "fza_ah64_fireArmedApu") # 1;

if !_battBusOn exitwith {};

switch(_engine) do {
    case "eng1": {
        if _value then {
            if ("fza_ah64_engine_1_fire" in (_heli getVariable "fza_audio_warning_message")) then {
                _heli setvariable ["fza_audio_warning_message", ""];
                _heli setVariable ["fza_ah64_mstrWarnLightOn", false, true];
            };
            _heli setVariable ["fza_ah64_fireArmed1", [true, _crewStation, CBA_missionTime], true];
        } else {
            if (_engineOneArm isEqualTo _crewStation) then {
                _heli setVariable ["fza_ah64_fireArmed1", [false, _crewStation, CBA_missionTime], true];
            };
        };
    };
    case "eng2": {
        if _value then {
            if ("fza_ah64_engine_1_fire" in (_heli getVariable "fza_audio_warning_message")) then {
                _heli setvariable ["fza_audio_warning_message", ""];
                _heli setVariable ["fza_ah64_mstrWarnLightOn", false, true];
            };
            _heli setVariable ["fza_ah64_fireArmed2", [true, _crewStation, CBA_missionTime], true];
        } else {
            if (_engineTwoArm isEqualTo _crewStation) then {
                _heli setVariable ["fza_ah64_fireArmed2", [false, _crewStation, CBA_missionTime], true];
            };
        };
    };
    case "apu": {
        if _value then {
            if ("fza_ah64_engine_1_fire" in (_heli getVariable "fza_audio_warning_message")) then {
                _heli setvariable ["fza_audio_warning_message", ""];
                _heli setVariable ["fza_ah64_mstrWarnLightOn", false, true];
            };
            _heli setVariable ["fza_ah64_fireArmedApu", [true, _crewStation, CBA_missionTime], true];
        } else {
            if (_engineApuArm isEqualTo _crewStation) then {
                _heli setVariable ["fza_ah64_fireArmedApu", [false, _crewStation, CBA_missionTime], true];
            };
        };
    };
};