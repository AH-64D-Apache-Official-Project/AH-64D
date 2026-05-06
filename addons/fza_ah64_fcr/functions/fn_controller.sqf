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
#include "\fza_ah64_systems\headers\systems.hpp"
params ["_heli"];

if ((player != driver _heli) && (isPlayer driver _heli)) exitWith {};

private _fcrEnabled = _heli animationPhase "fcr_enable" == 1;
private _fcrDamage  = _heli getHitPointDamage "hit_msnequip_fcr";
private _acBusOn    = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn    = _heli getVariable "fza_systems_dcBusOn";
private _onGnd      = [_heli] call fza_sfmplus_fnc_onGround;
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
