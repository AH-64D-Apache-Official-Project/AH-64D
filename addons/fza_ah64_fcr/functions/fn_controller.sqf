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
// The centerline goes all the way round the aircraft.
private _clWorld = _heli getVariable ["fza_ah64_fcrCenterlineWorld", -1];
if (_clWorld >= 0) then {
    private _azBias  = _heli getVariable ["fza_ah64_fcrAzBias", 0];
    private _newBias = [_clWorld - direction _heli] call CBA_fnc_simplifyAngle180;
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
// With the local crew station owning the FCR the centerline follows: the pilot's acquisition source, with PHS the
// pilot's head, slaved on selection; the CPG's acquisition source while slaved with FCR as the sight, or the TADS LOS
// while linked with TADS as the sight (TADSL). Otherwise it stays where it was put, or the slew arrows move it
// (fza_fcr_fnc_slewCenterline). At most 4 times a second and from 1 deg, and not during a scan, which holds the azimuth
// it was started on (fza_fcr_fnc_slaveCenterline); FCR and FXD hold the centerline where it was put.
private _isPilot = player == driver _heli;
private _sight   = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
private _tadsL   = player == gunner _heli && {CPG_LINK(_heli) && {_sight == SIGHT_TADS}};
if (_heli animationPhase "fcr_enable" == 1
    && {FCR_OWNER(_heli) == (["none", "cpg", "plt"] select ([player == gunner _heli, 2] select _isPilot))}
    && {_isPilot || _tadsL || {_sight == SIGHT_FCR && {_heli getVariable ["fza_ah64_cpgSlaved", false]}}}
    && {time - (_heli getVariable ["fza_fcr_slaveFollowTime", -1]) >= 0.25}) then {
    _heli setVariable ["fza_fcr_slaveFollowTime", time];
    private _acq = if (_tadsL) then {"TADS"} else {[_heli, [[0], [-1]] select _isPilot] call fza_fnc_targetingCurAcq};
    if !(_acq in ["FCR", "FXD"]) then {
        [_heli, _acq] call fza_fcr_fnc_slaveCenterline;
    };
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
