/* ----------------------------------------------------------------------------
Function: fza_light_fnc_controller

Description:
    fire control radar event init

Parameters:
    _heli - the helicopter to initialise

Returns:
    Nothing

Examples:
    [_heli] spawn fza_fcr_fnc_eventInit

Author:
    Snow(dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params["_heli"];

ace_map_vehicleLightCondition = {isLightOn [_vehicle, [0]]}; 

private _battBusOn    = _heli getVariable "fza_systems_battBusOn";
private _acBusOn      = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn      = _heli getVariable "fza_systems_dcBusOn";
private _landingLight = _heli getVariable "fza_ah64_lightpilot";
private _anticollanim = _heli getVariable "fza_ah64_anticollision";
private _anticollval  = isCollisionLightOn _heli;
private _landlightval = isLightOn _heli;
private _floodlight   = isLightOn [_heli, [0]];
private _powerOnState = (_acBusOn && _dcBusOn);

if !_battBusOn then {
    _heli setobjecttextureGlobal ["in_backlight", ""];
    _heli setobjecttextureGlobal ["in_backlight2", ""];
    if _floodlight then {
        [_heli, false] call fza_light_fnc_setFloodLight;
    };
    if (_landlightval) then {
        _heli setPilotLight false;
    };
} else {
    if (!_landlightval && _landingLight) then {
        _heli setPilotLight true;
    };
};

if !_powerOnState then {
    if !(_anticollval) exitwith {};
    _heli setCollisionLight false;
} else {
    if (!_anticollval && _anticollanim) then {
        _heli setCollisionLight true;
    };
};