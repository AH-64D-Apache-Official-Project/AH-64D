/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_tadsNvsControl

Description:
    Turns the TADS for the crewmember using it as their night vision sensor:
    NVS MODE NORM follows their helmet LOS at the TADS NVS slew rate, FIXED
    holds it fixed forward.

    The game's turret cannot be turned by the pilot, nor by the CPG while
    flying, so the TADS is turned by two script animations (tads_nvs_tur,
    tads_nvs) that add to the turret's own angles: each frame they are set to
    the wanted LOS less where the turret points, which is held straight ahead
    meanwhile (fza_fnc_weaponTurretAim). They are 0 whenever the TADS
    is not an NVS sensor, so the TADS is then the turret alone, as before:
    - only the crewmember with the TADS as NVS sets them, and only while the
      aircraft and they are alive, the power is on, the TADS has not failed
      and they are not looking through the TADS; otherwise they are zeroed;
    - NVS MODE OFF slews the TADS back onto the turret, then zeroes them;
    - every other crew station zeroes them when the crewmember setting them
      stops reporting (leaves the seat, disconnects).

    While the TADS is an NVS sensor it cannot be the CPG's sight, nor linked
    to the FCR; HMD and FCR remain, with flight symbology.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_ihadss_fnc_tadsNvsControl
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\bmkhs_helisim\functions\systems\systems.hpp"
params ["_heli"];

([_heli] call fza_ihadss_fnc_tadsNvs) params ["_mode", "_seat", "_unit"];

private _offAz   = -deg (_heli animationPhase "tads_nvs_tur");
private _offEl   = deg (_heli animationPhase "tads_nvs");
private _offset  = abs _offAz > 0.01 || {abs _offEl > 0.01};
private _driving = _heli getVariable ["fza_ihadss_tadsNvsDriving", false];

private _setOffset = {
    params ["_az", "_el"];
    [_heli, "tads_nvs_tur", -rad _az, true] call fza_anim_fnc_updateAnimations;
    [_heli, "tads_nvs", rad _el, true] call fza_anim_fnc_updateAnimations;
};
private _stop = {[_heli] call fza_ihadss_fnc_tadsNvsReset};

if (_mode != NVS_MODE_OFF && {player == gunner _heli}) then {
    private _sight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;
    if (isNil "_sight") then {_sight = SIGHT_HMD};
    if (_sight == SIGHT_TADS) then {
        ["fza_ah64_v30_sightSelectHMD", true] call fza_fnc_coreControlHandle;
    };
    if (CPG_LINK(_heli)) then {_heli setVariable ["fza_ah64_cpgLink", false, true]};
};

// Every other crew station: stop if this one was setting them, and zero them for a crewmember who stopped reporting. Seen
// unreported for the timeout here too, so a turn that arrives before its first report is not taken for a stale one.
if (_unit != player) exitWith {
    if (_driving) exitWith {call _stop};
    if (_offset && {CBA_missionTime - (_heli getVariable ["fza_ah64_tadsNvsReport", -1e6]) > TADS_NVS_REPORT_TIMEOUT}) then {
        private _since = _heli getVariable ["fza_ihadss_tadsNvsStaleSince", CBA_missionTime];
        _heli setVariable ["fza_ihadss_tadsNvsStaleSince", _since];
        if (CBA_missionTime - _since > TADS_NVS_REPORT_TIMEOUT) then {
            _heli setVariable ["fza_ihadss_tadsNvsStaleSince", nil];
            call _stop;
        };
    } else {
        _heli setVariable ["fza_ihadss_tadsNvsStaleSince", nil];
    };
};

private _powerOn = (_heli getVariable ["bmkhs_acBusOn", false]) && {_heli getVariable ["bmkhs_dcBusOn", false]};
private _failed  = _heli getHitPointDamage "hit_msnEquip_tads_turret" >= SYS_SIGHT_DMG_THRESH
    || {_heli getHitPointDamage "hit_msnEquip_tads_flir" >= SYS_SIGHT_DMG_THRESH};
// Heads down the CPG sees through the game's turret, so the TADS is the turret alone
if (!alive _heli || {!alive player} || {!_powerOn} || {_failed} || {cameraView == "GUNNER"}) exitWith {
    if (_driving || _offset) then {call _stop};
};
if (_mode == NVS_MODE_OFF && {!_driving} && {!_offset}) exitWith {};

private _turAz = -deg (_heli animationPhase "tads_tur");
private _turEl = deg (_heli animationPhase "tads");
private _dt    = (["fza_ihadss_tadsNvsSlew"] call BIS_fnc_deltaTime) min 0.1;
private _los   = _heli getVariable ["fza_ihadss_tadsNvsLos", [_turAz + _offAz, _turEl + _offEl]];

// With no IHADSS helmet, NORM has no head to follow: back onto the turret
if (_mode == NVS_MODE_NORM && {!([player] call fza_ihadss_fnc_hasHelmet)}) then {_mode = NVS_MODE_OFF};

private _want = switch (_mode) do {
    // The fixed LOS itself: the crew station's correction is for the head it follows in NORM
    case NVS_MODE_FIXED: {[0, NVS_FIXED_EL]};
    case NVS_MODE_NORM: {
        ((_heli vectorWorldToModelVisual getCameraViewDirection player) call CBA_fnc_vect2Polar) params ["", "_az", "_el"];
        _az = [_az] call CBA_fnc_simplifyAngle180;
        ([_heli, _seat, _az] call fza_ihadss_fnc_nvsBias) params ["_azBias", "_elBias"];
        [_az + _azBias, _el + _elBias]
    };
    // Off: back onto the turret, at the same rate
    default {[_turAz, _turEl]};
};
// Within the TADS gimbal, which the head can look beyond
_want = [(((_want # 0) max -120) min 120), (((_want # 1) max -60) min 30)];

private _step = TADS_NVS_SLEW_RATE * _dt;
_los = [
    (_los # 0) + ((((_want # 0) - (_los # 0)) max -_step) min _step),
    (_los # 1) + ((((_want # 1) - (_los # 1)) max -_step) min _step)
];

private _newAz = (_los # 0) - _turAz;
private _newEl = (_los # 1) - _turEl;
if (_mode == NVS_MODE_OFF && {abs _newAz < 0.05 && {abs _newEl < 0.05}}) exitWith {call _stop};

[_newAz, _newEl] call _setOffset;
_heli setVariable ["fza_ihadss_tadsNvsLos", _los];
_heli setVariable ["fza_ihadss_tadsNvsDriving", true];
// Reported twice a second, so the other crew station knows it is still set on purpose
if (CBA_missionTime - (_heli getVariable ["fza_ah64_tadsNvsReport", -1e6]) > 0.5) then {
    _heli setVariable ["fza_ah64_tadsNvsReport", CBA_missionTime, true];
};
