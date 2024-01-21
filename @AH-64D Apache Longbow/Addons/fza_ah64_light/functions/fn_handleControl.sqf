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
        private _turret   = ((_heli call fza_fnc_currentTurret) isEqualTo [-1]);
        private _variable  = ["fza_ah64_lightCpgFlood", "fza_ah64_lightPltFlood"] select _turret;
        private _hitpoint = ["#cpg_flood_sel", "#plt_flood_sel"] select _turret;
        private _hitval   = _heli getHitPointDamage _hitpoint;
        private _seat     = [[0],[-1]] select _turret;
        private _toggleon = (_hitval > 0.5);
        [_heli, _seat, _toggleon] call fza_light_fnc_setFloodLight;
        _heli setVariable [_variable, _toggleon];
        playsound "fza_ah64_button_rotary";
    };
    case "anticollision": {
        if !(_heli getVariable "fza_ah64_lightAntiColl") then {
            [_heli, "fza_ah64_lightAntiColl", true] call fza_fnc_animSetValue;
            if _powerOnState then {
                _heli setCollisionLight true;
            };
        } else {
            [_heli, "fza_ah64_lightAntiColl", false] call fza_fnc_animSetValue;
            _heli setCollisionLight false;
        };
        playsound "fza_ah64_switch_flip3";
    };
};