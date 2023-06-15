/* ----------------------------------------------------------------------------
Function: fza_fnc_fireHandleControl

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

private _turret = 0;
if (_heli turretLocal [0]) then {
    _turret = -1;
};

switch(_control) do {
    case "apu": {
        if (isnil "fza_ah64_firetest") then {
            fza_ah64_firetest = 0;
        };
        if (fza_ah64_firetest == 0) exitwith {
            _heli setobjecttexture ["in_lt_fire1", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_fire2", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_fireapu", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_mstrcau", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_mstrwrn", "\fza_ah64_us\tex\in\pushbut.paa"];
            fza_ah64_firetest = 1;

            if (player == driver _heli) then {
                _heli animateSource["plt_firesw", 1];
            } else {
                _heli animateSource["cpg_firesw", 0];
            };



            playsound "fza_ah64_switch_flip4";
            [player, "fza_ah64_warntest_3D"] remoteExec["say3d"];
        };
        if (fza_ah64_firetest == 1) exitwith {
            _heli setobjecttexture ["in_lt_fire1", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_fire2", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_fireapu", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_firepdis", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_firerdis", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_mstrcau", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_mstrwrn", "\fza_ah64_us\tex\in\pushbut.paa"];
            fza_ah64_firetest = 2;

            if (player == driver _heli) then {
                _heli animateSource["plt_firesw", 0];
            } else {
                _heli animateSource["cpg_firesw", 1];
            };

            playsound "fza_ah64_switch_flip4";
            [player, "fza_ah64_warntest_3D"] remoteExec["say3d"];
        };
        if (fza_ah64_firetest == 2) exitwith {
            _heli setobjecttexture ["in_lt_fire1", ""];
            _heli setobjecttexture ["in_lt_fire2", ""];
            _heli setobjecttexture ["in_lt_fireapu", ""];
            _heli setobjecttexture ["in_lt_mstrcau", ""];
            _heli setobjecttexture ["in_lt_mstrwrn", ""];
            if !(_heli getVariable "fza_ah64_firepdisch") then {
                _heli setobjecttexture ["in_lt_firepdis", ""];
            };
            if !(_heli getVariable "fza_ah64_firerdisch") then {
                _heli setobjecttexture ["in_lt_firerdis", ""];
            };
            fza_ah64_firetest = 0;

            if (player == driver _heli) then {
                _heli animateSource["plt_firesw", 0.5];
            } else {
                _heli animateSource["cpg_firesw", 0.5];
            };

            playsound "fza_ah64_switch_flip4";
        };
    };
    case "fe1": {
        [_heli, "eng1", !(_heli getVariable "fza_ah64_fire1arm")] call fza_fnc_fireHandlepanel;
        ["fza_ah64_button_click2", 0.1];
    };
    case "fe2": {
        [_heli, "eng2", !(_heli getVariable "fza_ah64_fire2arm")] call fza_fnc_fireHandlepanel;
        ["fza_ah64_button_click2", 0.1];
    };
    case "fapu": {
        [_heli, "apu", !(_heli getVariable "fza_ah64_fireapuarm")] call fza_fnc_fireHandlepanel;
        ["fza_ah64_button_click2", 0.1];
    };
    case "fbp": {
        if ((_heli getVariable "fza_ah64_fireapuarm" || _heli getVariable "fza_ah64_fire2arm" || _heli getVariable "fza_ah64_fire1arm") && !(_heli getVariable "fza_ah64_firepdisch")) then {
                _heli setobjecttexture ["in_lt_firepdis", "\fza_ah64_us\tex\in\pushbut.paa"];
                [_heli, "fza_ah64_firepdisch", true] call fza_fnc_updateNetworkGlobal;
                _dmg = vehicle player getHit "leng";
                vehicle player setHit ["leng", _dmg + 0.01];
            };
            ["fza_ah64_button_click2", 0.1];
        };
        case "fbr": {
            if ((_heli getVariable "fza_ah64_fireapuarm" || _heli getVariable "fza_ah64_fire2arm" || _heli getVariable "fza_ah64_fire1arm") && !(_heli getVariable "fza_ah64_firerdisch")) then {
                _heli setobjecttexture ["in_lt_firerdis", "\fza_ah64_us\tex\in\pushbut.paa"];
                [_heli, "fza_ah64_firerdisch", true] call fza_fnc_updateNetworkGlobal;
                _dmg = vehicle player getHit "Reng";
                vehicle player setHit ["Reng", _dmg + 0.01];
            };
            ["fza_ah64_button_click2", 0.1];
        };
        case "test": {
            if (isnil "fza_ah64_firetest") then {
            fza_ah64_firetest = 0;
        };
        if (fza_ah64_firetest == 0) exitwith {
            _heli setobjecttexture ["in_lt_fire1", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_fire2", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_fireapu", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_mstrcau", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_mstrwrn", "\fza_ah64_us\tex\in\pushbut.paa"];
            fza_ah64_firetest = 1;

            if (player == driver _heli) then {
                _heli animateSource["plt_firesw", 1];
            } else {
                _heli animateSource["cpg_firesw", 0];
            };

            playsound "fza_ah64_switch_flip4";
            [player, "fza_ah64_warntest_3D"] remoteExec["say3d"];
        };
        if (fza_ah64_firetest == 1) exitwith {
            _heli setobjecttexture ["in_lt_fire1", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_fire2", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_fireapu", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_firepdis", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_firerdis", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_mstrcau", "\fza_ah64_us\tex\in\pushbut.paa"];
            _heli setobjecttexture ["in_lt_mstrwrn", "\fza_ah64_us\tex\in\pushbut.paa"];
            fza_ah64_firetest = 2;

            if (player == driver _heli) then {
                _heli animateSource["plt_firesw", 0];
            } else {
                _heli animateSource["cpg_firesw", 1];
            };

            playsound "fza_ah64_switch_flip4";
            [player, "fza_ah64_warntest_3D"] remoteExec["say3d"];
        };
        if (fza_ah64_firetest == 2) exitwith {
            _heli setobjecttexture ["in_lt_fire1", ""];
            _heli setobjecttexture ["in_lt_fire2", ""];
            _heli setobjecttexture ["in_lt_fireapu", ""];
            _heli setobjecttexture ["in_lt_mstrcau", ""];
            _heli setobjecttexture ["in_lt_mstrwrn", ""];
            if !(_heli getVariable "fza_ah64_firepdisch") then {
                _heli setobjecttexture ["in_lt_firepdis", ""];
            };
            if !(_heli getVariable "fza_ah64_firerdisch") then {
                _heli setobjecttexture ["in_lt_firerdis", ""];
            };
            fza_ah64_firetest = 0;

            if (player == driver _heli) then {
                _heli animateSource["plt_firesw", 0.5];
            } else {
                _heli animateSource["cpg_firesw", 0.5];
            };

            playsound "fza_ah64_switch_flip4";
        };
    };
};