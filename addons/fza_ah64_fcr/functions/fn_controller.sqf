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
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

// A slewed centerline holds its world bearing while the aircraft yaws.
// Derived locally on every machine from the replicated world bearing — no per-frame traffic.
// Centerline drags against one scan azimuth off the nose (both GTM/RMAP and ATM).
private _clWorld = _heli getVariable ["fza_ah64_fcrCenterlineWorld", -1];
if (_clWorld >= 0) then {
    private _azBias  = _heli getVariable ["fza_ah64_fcrAzBias", 0];
    private _newBias = [_clWorld - direction _heli] call CBA_fnc_simplifyAngle180;
    private _lim     = if ((_heli getVariable "fza_ah64_fcrMode") == FCR_DISP_MODE_ATM) then {
        _heli getVariable ["fza_ah64_fcrAtmHalfFov", 168]
    } else {
        _heli getVariable ["fza_ah64_fcrGtmHalfFov", 45]
    };
    _newBias = (_newBias min _lim) max -_lim;
    if (abs (_newBias - _azBias) > 0.1) then {
        _heli setVariable ["fza_ah64_fcrAzBias", _newBias];
    };
};

_heli call fza_fcr_fnc_resolveDisplay;
[_heli] call fza_fcr_fnc_updateTPMObstacles;
// The HMD profile lines need TPM sampling even when no MPD shows the TPM page
if ((_heli getVariable "fza_ah64_fcrMode") == FCR_DISP_MODE_TPM && { _heli getVariable ["fza_ah64_fcrcscope", false] }) then {
    [_heli] call fza_fcr_fnc_tpmSample;
};

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
