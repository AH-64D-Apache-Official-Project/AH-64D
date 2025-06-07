/* ----------------------------------------------------------------------------
Function: fza_fire_fnc_handleControl

Description:
    Handles any fire-related cockpit controls.

Parameters:
    _heli - The helicopter to act on
    _system - the name of the system that the touched control belongs to
    _control - the name of the control that has been touched

Returns:
    Nothing

Examples:
    --- Code
    [_heli, "fire", "fe1"] call fireHandleControl
    ---

Author:
    Unknown, mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli", "_system", "_control"];

private _battBusOn          = _heli getVariable "fza_systems_battBusOn";
private _engineOneArm       = (_heli getVariable "fza_ah64_fireArmed1") # 0;
private _engineTwoArm       = (_heli getVariable "fza_ah64_fireArmed2") # 0;
private _apuArm             = (_heli getVariable "fza_ah64_fireArmedApu") # 0;
private _primaryFbAvailable = !(_heli getVariable "fza_ah64_firepdisch");
private _reserveFBAvailable = !(_heli getVariable "fza_ah64_firerdisch");

switch(_control) do {
    case "fe1": {
        [_heli, "eng1", !_engineOneArm] call fza_fire_fnc_handlePanel;
        ["fza_ah64_button_click2", 0.1];
    };
    case "fe2": {
        [_heli, "eng2", !_engineTwoArm] call fza_fire_fnc_handlePanel;
        ["fza_ah64_button_click2", 0.1];
    };
    case "fapu": {
        [_heli, "apu", !_apuArm] call fza_fire_fnc_handlePanel;
        ["fza_ah64_button_click2", 0.1];
    };
    case "fbp": {
        if ((_engineOneArm || _engineTwoArm || _apuArm) && _primaryFbAvailable) then {
                _heli setVariable ["fza_ah64_firepdisch", true, true];
                if (_heli getHitPointDamage "hitengine1" == 0) then {
                    _heli setHitPointDamage  ["hitengine1", 0.01];
                };
            };
            ["fza_ah64_button_click2", 0.1];
        };
    case "fbr": {
        if ((_engineOneArm || _engineTwoArm || _apuArm) && _reserveFBAvailable) then {
            _heli setVariable ["fza_ah64_firerdisch", true, true];
            if (_heli getHitPointDamage "hitengine2" == 0) then {
                _heli setHitPointDamage  ["hitengine2", 0.01];
            };
        };
        ["fza_ah64_button_click2", 0.1];
    };
    case 0: {
        _heli setVariable ["fza_ah64_firetest", 1, true];
        _heli setVariable ["fza_ah64_aft_deck_fire", true, true];
        if _battBusOn then {
            [_heli] spawn {
                params ["_heli"];
                private _audioPlaying = _heli getvariable "fza_ah64_firetestAudioPlaying";
                if (!_audioPlaying) then {
                    _heli setVariable ["fza_ah64_firetestAudioPlaying", true, true];
                    player say3d "fza_ah64_engine_1_fire";
                    player say3d "fza_ah64_APU_fire";
                    player say3d "fza_ah64_engine_2_fire";
                    player say3d "fza_ah64_aft_deck_fire";
                    sleep 5;
                    _heli setVariable ["fza_ah64_firetestAudioPlaying", false, true];
                };
            };
        };
    };
    case 1: {
        _heli setVariable ["fza_ah64_firetest", 2, true];
        _heli setVariable ["fza_ah64_aft_deck_fire", true, true];
        if _battBusOn then {
            [_heli] spawn {
                params ["_heli"];
                private _audioPlaying = _heli getvariable "fza_ah64_firetestAudioPlaying";
                if (!_audioPlaying) then {
                    _heli setVariable ["fza_ah64_firetestAudioPlaying", true, true];
                    player say3d "fza_ah64_engine_1_fire";
                    player say3d "fza_ah64_APU_fire";
                    player say3d "fza_ah64_engine_2_fire";
                    player say3d "fza_ah64_aft_deck_fire";
                    sleep 5;
                    _heli setVariable ["fza_ah64_firetestAudioPlaying", false, true];
                };
            };
        };
    };
    case 0.5: {
        _heli setVariable ["fza_ah64_firetest", 0, true];
        _heli setVariable ["fza_ah64_aft_deck_fire", false, true];
        _heli setVariable ["fza_ah64_mstrWarnLightOn", false, true];
    };
};