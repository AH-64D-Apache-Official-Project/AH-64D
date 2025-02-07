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

private _battBusOn    = _heli getVariable "fza_systems_battBusOn";
private _acBusOn      = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn      = _heli getVariable "fza_systems_dcBusOn";
private _landingLight = _heli getVariable "fza_ah64_lightSearchLight";
private _anticollanim = _heli getVariable "fza_ah64_lightAntiColl";
private _pltFloodVal  = _heli getVariable "fza_ah64_lightPltFlood";
private _CpgFloodVal  = _heli getVariable "fza_ah64_lightCpgFlood";
private _landlightval = _heli animationSourcePhase "landing_light";
private _pltFloodOn   = _heli animationSourcePhase "plt_flood";
private _cpgFloodOn   = _heli animationSourcePhase "cpg_flood";
private _anticollval  = isCollisionLightOn _heli;
private _powerOnState = (_acBusOn && _dcBusOn);

//force pilot light
if (!isLightOn _heli && CBA_missionTime > 0) then {
    _heli setPilotLight true;
};

if !_battBusOn then {
    if (_pltFloodOn == 1) then {
        [_heli, [-1], false] call fza_light_fnc_setFloodLight;
    };
    if (_cpgFloodOn == 1) then {
        [_heli, [0], false] call fza_light_fnc_setFloodLight;
    };
    if (_landlightval == 1) then {
        _heli animateSource ["landing_light", 0];
    };
} else {
    if (_pltFloodOn == 0 && _pltFloodVal) then {
        [_heli, [-1], true] call fza_light_fnc_setFloodLight;
    };
    if (_cpgFloodOn == 0 && _cpgFloodVal) then {
        [_heli, [0], true] call fza_light_fnc_setFloodLight;
    };
    if (_landlightval == 0 && _landingLight) then {
        _heli animateSource ["landing_light", 1];
    };
    if (_landlightval == 1 && !_landingLight) then {
        _heli animateSource ["landing_light", 0];
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
    if (_anticollval && !_anticollanim) then {
        _heli setCollisionLight false;
    };
};

private _turret = _heli call fza_fnc_currentTurret;
private _aceMapLighting = false;
if (_turret isEqualTo [-1] && _pltFloodOn == 1) then {_aceMapLighting = true;};
if (_turret isEqualTo [0] && _cpgFloodOn == 1) then {_aceMapLighting = true;};
ace_map_vehicleLightCondition = _aceMapLighting;