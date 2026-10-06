/* ----------------------------------------------------------------------------
Function: fza_anim_fnc_rotorSpin

Description:
    Spins the rotors and swaps blades for blur from HeliSim's rotor RPM.
    Runs where the aircraft is local. Every command here is global, so it only
    sends when the RPM has moved; each client then carries the spin on itself.

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

params ["_heli"];

private _rpm = _heli getVariable ["bmkhs_rtrRpm", 0];
if (_rpm < 0.002) then {_rpm = 0};
(_heli getVariable ["fza_anim_rotorSent", [-1, false]]) params ["_sent", "_wasBlur"];

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
if !(_wrap || _changed) exitWith {};

{
    if (_rpm == 0) then {
        _heli animateSource [_x, _heli animationSourcePhase _x, true];
    } else {
        _heli animateSource [_x, ROTOR_PHASE_TARGET, _rpm];
    };
} forEach ["rotorHUser", "rotorVUser"];

//Held to its side of the threshold so the blur animation follows the latched state
_heli animateSource ["mainRotorRPMUser", [_rpm min (ROTOR_BLUR_RPM - 0.01), _rpm max ROTOR_BLUR_RPM] select _blur];

if (_sent < 0 || {_blur isNotEqualTo _wasBlur}) then {
    private _texture = ["\fza_ah64_model\tex\ex\rtrs_co.paa", ""] select _blur;
    _heli setObjectTextureGlobal ["mr_blades", _texture];
    _heli setObjectTextureGlobal ["tr_blades", _texture];
};

_heli setVariable ["fza_anim_rotorSent", [_rpm, _blur]];
