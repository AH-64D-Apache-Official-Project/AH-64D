/* ----------------------------------------------------------------------------
Function: fza_light_fnc_handleControl

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
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli", "_system", "_control"];

private _battBusOn = _heli getVariable "fza_systems_battBusOn";
private _acBusOn   = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn   = _heli getVariable "fza_systems_dcBusOn";
private _powerOnState = (_acBusOn && _dcBusOn);

switch (_control) do {
    case "floodlight": {
        if (!isLightOn [_heli,[0]] && _battBusOn) then {
            _heli setObjectTextureGlobal ["in_backlight", "\fza_ah64_us\tex\in\dlt.paa"];
            _heli setobjecttextureGlobal ["in_backlight2", "\fza_ah64_us\tex\in\pushbut.paa"];

            [_heli, true] call fza_light_fnc_setFloodLight;

        } else {
            _heli setobjecttextureGlobal ["in_backlight", ""];
            _heli setobjecttextureGlobal ["in_backlight2", ""];

            [_heli, false] call fza_light_fnc_setFloodLight;

        };
        playsound "fza_ah64_button_rotary";
    };
    case "anticollision": {
        if !(_heli getVariable "fza_ah64_anticollision") then {
            [_heli, "fza_ah64_anticollision", true] call fza_fnc_animSetValue;
            if _powerOnState then {
                _heli setCollisionLight true;
            };
        } else {
            [_heli, "fza_ah64_anticollision", false] call fza_fnc_animSetValue;
            _heli setCollisionLight false;
        };
        playsound "fza_ah64_switch_flip3";
    };
};