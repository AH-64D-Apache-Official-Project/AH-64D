/* ----------------------------------------------------------------------------
Function: fza_anim_fnc_rotorAnim

Description:
    Drives swashplate, blade pitch, and tail rotor animations from HeliSim data.

    Main rotor swashplate:
      • Translation  (swashplate_up/dn_tns, mr_act_tns) ← collective
        collective 0→1 maps to animation phase -1→+1 (model minValue/maxValue)
      • Pitch tilt   (swashplate_up/dn_pitch)             ← effective cyclic pitch
      • Bank tilt    (swashplate_up/dn_bank)              ← effective cyclic bank
      • Push-rod arms (swup_arm1-4 + _t variants)         ← cyclic pitch/bank

    Main rotor blades:
      • Blade pitch  (blade1-4_pitch) ← collective always, plus per-blade cyclic
        contribution when RPM < blur threshold (mr_blades selection visible):
          blade_pitch = collective ± cyclicBladePct × effPitch/effRoll
        Assumed model azimuths: blade1=0°, blade2=90°, blade3=180°, blade4=270°

    Tail rotor:
      • Swashplate translation (trsw, model range -5…+5) ← effective pedal ×5
      • Blade pitch (tr_blade1-4_pitch)                  ← effective pedal

    "Effective" cyclic/pedal replicates bmkhs_fnc_inputGetInterp so the
    model visuals match the flight model at all trim positions.

Parameters:
    _heli - The helicopter object [Object]

Returns:
    Nothing

Author:
    FZA AH-64D Project
---------------------------------------------------------------------------- */
#include "\fza_ah64_animation\headers\rotor.hpp"
params ["_heli"];

if (player != currentPilot _heli) exitWith {};


// ── Read inputs ──────────────────────────────────────────────────────────────
private _cyclicFwd  = _heli getVariable ["bmkhs_cyclicFwdAft",    0.0];
private _cyclicBank = _heli getVariable ["bmkhs_cyclicLeftRight",  0.0];
private _ftPitch    = _heli getVariable ["bmkhs_forceTrimPosPitch",   0.0];
private _ftRoll     = _heli getVariable ["bmkhs_forceTrimPosRoll",    0.0];
private _collective = _heli getVariable ["bmkhs_collectiveOutput", 0.0];
private _pedal      = _heli getVariable ["bmkhs_pedalLeftRight",   0.0];
private _ftPedal    = _heli getVariable ["bmkhs_forceTrimPosYaw",        0.0];
private _rtrRPM     = _heli getVariable ["bmkhs_rtrRpm",          0.0];

//Spin itself is fza_anim_fnc_rotorSpin; this only reads where the rotor is
private _rotorPhase = (_heli animationSourcePhase "rotorHUser") mod 1;

// ── Effective values ──────────────────────────────────────────────────────────
private _effPitch = [_cyclicFwd,  _ftPitch] call fza_anim_fnc_getEffInput;
private _effRoll  = [_cyclicBank, _ftRoll]  call fza_anim_fnc_getEffInput;
private _effPedal = [_pedal,      _ftPedal] call fza_anim_fnc_getEffInput;

#define CYCLIC_BLADE_PCT  0.5
#define CYCLIC_PHASE_OFFSET 90

if (_rtrRPM < ROTOR_BLUR_RPM) then {
    private _rotorAz   = _rotorPhase * 360;
    private _cyclicDir = ([0, 0] getDir [_effRoll, _effPitch]) + CYCLIC_PHASE_OFFSET;
    private _cyclicMag = [vectorMagnitude [_effPitch, _effRoll], 0, 1] call BIS_fnc_clamp;
    private _b1 = [_collective - CYCLIC_BLADE_PCT * _cyclicMag * sin((_rotorAz +  45) - _cyclicDir), -1, 1] call BIS_fnc_clamp;
    private _b2 = [_collective - CYCLIC_BLADE_PCT * _cyclicMag * sin((_rotorAz + 135) - _cyclicDir), -1, 1] call BIS_fnc_clamp;
    private _b3 = [_collective - CYCLIC_BLADE_PCT * _cyclicMag * sin((_rotorAz + 225) - _cyclicDir), -1, 1] call BIS_fnc_clamp;
    private _b4 = [_collective - CYCLIC_BLADE_PCT * _cyclicMag * sin((_rotorAz + 315) - _cyclicDir), -1, 1] call BIS_fnc_clamp;
    [_heli, "blade1_pitch", _b1, true] call fza_anim_fnc_updateAnimations;
    [_heli, "blade2_pitch", _b2, true] call fza_anim_fnc_updateAnimations;
    [_heli, "blade3_pitch", _b3, true] call fza_anim_fnc_updateAnimations;
    [_heli, "blade4_pitch", _b4, true] call fza_anim_fnc_updateAnimations;
} else {
    // Blur state: uniform collective pitch (blades not visible individually)
    [_heli, "blade1_pitch", _collective, true] call fza_anim_fnc_updateAnimations;
    [_heli, "blade2_pitch", _collective, true] call fza_anim_fnc_updateAnimations;
    [_heli, "blade3_pitch", _collective, true] call fza_anim_fnc_updateAnimations;
    [_heli, "blade4_pitch", _collective, true] call fza_anim_fnc_updateAnimations;
};

// ── Tail rotor ───────────────────────────────────────────────────────────────
// trsw: model minValue=-5, maxValue=5 → pedal -1…+1 maps to -5…+5
[_heli, "trsw", _effPedal* 5, true] call fza_anim_fnc_updateAnimations;
// Blades 1 & 4 face opposite to 2 & 3 in the model, so their pitch sign is reversed
[_heli, "tr_blade1_pitch", -_effPedal,   true] call fza_anim_fnc_updateAnimations;
[_heli, "tr_blade2_pitch",  _effPedal,   true] call fza_anim_fnc_updateAnimations;
[_heli, "tr_blade3_pitch",  _effPedal,   true] call fza_anim_fnc_updateAnimations;
[_heli, "tr_blade4_pitch", -_effPedal,   true] call fza_anim_fnc_updateAnimations;
