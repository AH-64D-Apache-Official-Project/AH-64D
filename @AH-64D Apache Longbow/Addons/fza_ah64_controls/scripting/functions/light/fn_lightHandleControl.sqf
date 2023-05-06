/* ----------------------------------------------------------------------------
Function: fza_fnc_lightHandleControl

Description:
    Handles any light-related cockpit controls.

Parameters:
    _heli - The helicopter to act on
    _system - the name of the system that the touched control belongs to
    _control - the name of the control that has been touched

Returns:
    Nothing

Examples:
    --- Code
    [_heli, "light", "floodlight"] call_lightHandleControl
    ---

Author:
    Unknown, mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli", "_system", "_control"];

switch (_control) do {
    case "floodlight": {
        if (!(isLightOn [_heli,[0]]) && _heli getVariable "fza_ah64_battery") then {
            _heli setObjectTextureGlobal ["in_backlight", "\fza_ah64_us\tex\in\dlt.paa"];
            _heli setobjecttextureGlobal ["in_backlight2", "\fza_ah64_us\tex\in\pushbut.paa"];

            [_heli, true] call fza_fnc_lightSetCockpitLight;

        } else {
            _heli setobjecttextureGlobal ["in_backlight", ""];
            _heli setobjecttextureGlobal ["in_backlight2", ""];

            [_heli, false] call fza_fnc_lightSetCockpitLight;

        };
        playsound "fza_ah64_button_rotary";
    };
    case "anticollision": {
        if (!(_heli getVariable "fza_ah64_anticollision") && _heli getVariable "fza_ah64_battery") then {
            [_heli, "fza_ah64_anticollision", true] call fza_fnc_animSetValue;
            _heli setCollisionLight true;
        } else {
            [_heli, "fza_ah64_anticollision", false] call fza_fnc_animSetValue;
            _heli setCollisionLight false;
        };
        playsound "fza_ah64_switch_flip3";
    };
};