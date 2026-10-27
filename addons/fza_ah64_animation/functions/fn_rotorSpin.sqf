/* ----------------------------------------------------------------------------
Function: fza_anim_fnc_rotorSpin

Description:
    Spins the rotors and sets the blur from HeliSim's rotor RPM. Runs where
    the aircraft is local. Every command here is global, so it only sends when
    the RPM has moved; each client then carries the spin on itself. While the
    rotor turns, the blur alone is sent again every 5 s, so a machine that
    joined since catches up. Each machine shows the blades or the blur itself
    (fza_anim_fnc_rotorBlades).

Parameters:
    _heli - The helicopter [Object]

Returns:
    Nothing

Examples:
    [_heli] call fza_anim_fnc_rotorSpin

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_animation\headers\rotor.hpp"
#define ROTOR_RESEND 5

params ["_heli"];

private _rpm = _heli getVariable ["bmkhs_rtrRpm", 0];
if (_rpm < 0.002) then {_rpm = 0};
(_heli getVariable ["fza_anim_rotorSent", [-1, false, -1e6]]) params ["_sent", "_wasBlur", ["_sentAt", -1e6]];

//Phase is a float, so it is brought back near zero before it loses precision
private _wrap = (_heli animationSourcePhase "rotorVUser") > ROTOR_PHASE_WRAP;
if (_wrap) then {
    {
        _heli animateSource [_x, (_heli animationSourcePhase _x) mod 1, true];
    } forEach ["rotorHUser", "rotorVUser"];
};

private _blur = [_rpm >= ROTOR_BLUR_RPM + ROTOR_BLUR_HYST, _rpm > ROTOR_BLUR_RPM - ROTOR_BLUR_HYST] select _wasBlur;
private _step = (_sent * ROTOR_RPM_STEP_REL) max ROTOR_RPM_STEP_MIN min ROTOR_RPM_STEP_MAX;
private _changed = abs (_rpm - _sent) >= _step
                || {_blur isNotEqualTo _wasBlur}
                || {_rpm == 0 && _sent != 0};
//Held to its side of the threshold so the blur animation follows the latched state
private _blurPhase = [_rpm min (ROTOR_BLUR_RPM - 0.01), _rpm max ROTOR_BLUR_RPM] select _blur;
if !(_wrap || _changed) exitWith {
    if (_rpm > 0 && {time - _sentAt >= ROTOR_RESEND}) then {
        _heli animateSource ["mainRotorRPMUser", _blurPhase];
        _heli setVariable ["fza_anim_rotorSent", [_sent, _wasBlur, time]];
    };
};

{
    if (_rpm == 0) then {
        _heli animateSource [_x, _heli animationSourcePhase _x, true];
    } else {
        _heli animateSource [_x, ROTOR_PHASE_TARGET, _rpm];
    };
} forEach ["rotorHUser", "rotorVUser"];

_heli animateSource ["mainRotorRPMUser", _blurPhase];

_heli setVariable ["fza_anim_rotorSent", [_rpm, _blur, time]];
