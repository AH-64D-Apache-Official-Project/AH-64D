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

private _crewStation        = _heli call fza_fnc_currentTurret;
private _engineOneArm       = (_heli getVariable "fza_ah64_fireArmed1") # 0;
private _engineTwoArm       = (_heli getVariable "fza_ah64_fireArmed2") # 0;
private _engineApuArm       = (_heli getVariable "fza_ah64_fireArmedApu") # 0;
private _primaryFbAvailable = !(_heli getVariable "fza_ah64_firepdisch");
private _reserveFBAvailable = !(_heli getVariable "fza_ah64_firerdisch");
private _fireTestState      = _heli getvariable "fza_ah64_firetest";

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
        [_heli, "apu", !_engineApuArm] call fza_fire_fnc_handlePanel;
        ["fza_ah64_button_click2", 0.1];
    };
    case "fbp": {
        if ((_engineOneArm || _engineTwoArm || _engineApuArm) && _primaryFbAvailable) then {
                _heli setVariable ["fza_ah64_firepdisch", true, true];
                if (_heli getHitPointDamage "hitengine1" == 0) then {
                    _heli setHitPointDamage  ["hitengine1", 0.01];
                };
            };
            ["fza_ah64_button_click2", 0.1];
        };
    case "fbr": {
        if ((_engineOneArm || _engineTwoArm || _engineApuArm) && _reserveFBAvailable) then {
            _heli setVariable ["fza_ah64_firerdisch", true, true];
            if (_heli getHitPointDamage "hitengine2" == 0) then {
                _heli setHitPointDamage  ["hitengine2", 0.01];
            };
        };
        ["fza_ah64_button_click2", 0.1];
    };
    case "test": {
        if (_fireTestState == 0) exitwith {
            _heli setVariable ["fza_ah64_firetest", 1];
            _heli animateSource [["cpg_firesw", "plt_firesw"] select (player == driver _heli), 1];
            playsound "fza_ah64_switch_flip4";
            if _battBusOn then {
                _heli setVariable ["fza_ah64_mstrWarnLightOn", true, true];
                player say3d "fza_ah64_aft_deck_fire";
                player say3d "fza_ah64_engine_1_fire";
                player say3d "fza_ah64_engine_2_fire";
                player say3d "fza_ah64_APU_fire";
            };
        };
        if (_fireTestState == 1) exitwith {
            _heli setVariable ["fza_ah64_firetest", 2];
            _heli animateSource [["cpg_firesw", "plt_firesw"] select (player == driver _heli), 0];
            playsound "fza_ah64_switch_flip4";
            if _battBusOn then {
                _heli setVariable ["fza_ah64_mstrWarnLightOn", true, true];
                player say3d "fza_ah64_aft_deck_fire";
                player say3d "fza_ah64_engine_1_fire";
                player say3d "fza_ah64_engine_2_fire";
                player say3d "fza_ah64_APU_fire";
            };
        };
        if (_fireTestState == 2) exitwith {
            _heli setVariable ["fza_ah64_firetest", 0];
            _heli animateSource [["cpg_firesw", "plt_firesw"] select (player == driver _heli), 0.5];
            _heli setVariable ["fza_ah64_mstrWarnLightOn", false, true];
            playsound "fza_ah64_switch_flip4";
        };
    };
};