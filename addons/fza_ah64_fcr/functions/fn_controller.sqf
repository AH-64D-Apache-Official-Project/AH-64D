/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_controller

Description:
    Handles per-frame FCR state and animation. Local pilot only.

Parameters:
    _heli - The helicopter to act upon

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\bmkhs_helisim\functions\systems\systems.hpp"
params ["_heli"];

_heli call fza_fcr_fnc_resolveDisplay;

if ((player != driver _heli) && (isPlayer driver _heli)) exitWith {};

private _fcrEnabled = _heli animationPhase "fcr_enable" == 1;
private _fcrDamage  = _heli getHitPointDamage "hit_msnEquip_fcr";
private _acBusOn    = _heli getVariable "bmkhs_acBusOn";
private _dcBusOn    = _heli getVariable "bmkhs_dcBusOn";
private _onGnd      = [_heli] call bmkhs_fnc_stateOnGround;
private _gndOrideOn = _heli getVariable "fza_ah64_gndOrideOn";
private _lockout    = _fcrDamage >= SYS_FCR_DMG_THRESH || !_acBusOn || !_dcBusOn || (_onGnd && !_gndOrideOn);

if (!_fcrEnabled || _lockout) then {
    _heli enableVehicleSensor ["ActiveRadarSensorComponent", false];
} else {
    _heli enableVehicleSensor ["ActiveRadarSensorComponent", true];
};

if (_heli animationPhase "fcr_enable" != 1) exitWith {};

[_heli] call fza_fcr_fnc_stateControl;
[_heli] call fza_fcr_fnc_animateFCR;
