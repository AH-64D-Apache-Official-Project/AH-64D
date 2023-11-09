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
private _landingLight = _heli getVariable "fza_ah64_lightSearchLight";
private _anticollanim = _heli getVariable "fza_ah64_lightAntiColl";
private _pltFloodVal  = _heli getVariable "fza_ah64_lightPltFlood";
private _CpgFloodVal  = _heli getVariable "fza_ah64_lightCpgFlood";
private _landlightval = _heli getHitPointDamage "#landing_light";
private _pltFloodOn   = _heli getHitPointDamage "#plt_flood_sel";
private _cpgFloodOn   = _heli getHitPointDamage "#cpg_flood_sel";
private _anticollval  = isCollisionLightOn _heli;
private _powerOnState = (_acBusOn && _dcBusOn);

//force pilot light
if !(isLightOn _heli) then {
    _heli setPilotLight true;
};

if !_battBusOn then {
    if (_pltFloodOn == 0) then {
        [_heli, [-1], false] call fza_light_fnc_setFloodLight;
    };
    if (_cpgFloodOn == 0) then {
        [_heli, [0], false] call fza_light_fnc_setFloodLight;
    };
    if (_landlightval == 0) then {
        _heli setHitPointDamage ["#landing_light", 1];
    };
} else {
    if (_pltFloodOn == 1 && _pltFloodVal == true) then {
        [_heli, [-1], true] call fza_light_fnc_setFloodLight;
    };
    if (_cpgFloodOn == 1 && _cpgFloodVal == true) then {
        [_heli, [0], true] call fza_light_fnc_setFloodLight;
    };
    if (_landlightval == 1 && _landingLight) then {
        _heli setHitPointDamage ["#landing_light", 0];
    };
    if (_landlightval == 0 && !_landingLight) then {
        _heli setHitPointDamage ["#landing_light", 1];
    };
};

if !_powerOnState then {
    if (_anticollval) then {
        _heli setCollisionLight false;
    };
} else {
    if (!_anticollval && _anticollanim) then {
        _heli setCollisionLight true;
    };
};