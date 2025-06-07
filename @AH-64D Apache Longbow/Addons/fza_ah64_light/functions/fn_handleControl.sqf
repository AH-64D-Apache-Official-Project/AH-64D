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
    case "FLOODLIGHTING": {
        private _turret   = ((_heli call fza_fnc_currentTurret) isEqualTo [-1]);
        private _variable  = ["fza_ah64_lightCpgFlood", "fza_ah64_lightPltFlood"] select _turret;
        private _value = !(_heli getvariable _variable);
        _heli setVariable [_variable, _value];
        [_heli, (_heli call fza_fnc_currentTurret), _value] call fza_light_fnc_setFloodLight;
    };
    case "ANTI-COLLISION ON": {
        [_heli, "fza_ah64_lightAntiColl", true] call fza_fnc_animSetValue;
    };
    case "ANTI-COLLISION OFF": {
        [_heli, "fza_ah64_lightAntiColl", false] call fza_fnc_animSetValue;
    };
};