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

    "Effective" cyclic/pedal replicates fza_sfmplus_fnc_getInterpInput so the
    model visuals match the flight model at all trim positions.

Parameters:
    _heli - The helicopter object [Object]

Returns:
    Nothing

Author:
    FZA AH-64D Project
---------------------------------------------------------------------------- */
params ["_heli"];

// ── Read inputs ──────────────────────────────────────────────────────────────
private _cyclicFwd  = _heli getVariable ["fza_sfmplus_cyclicFwdAft",    0.0];
private _cyclicBank = _heli getVariable ["fza_sfmplus_cyclicLeftRight",  0.0];
private _ftPitch    = _heli getVariable ["fza_ah64_forceTrimPosPitch",   0.0];
private _ftRoll     = _heli getVariable ["fza_ah64_forceTrimPosRoll",    0.0];
private _collective = _heli getVariable ["fza_sfmplus_collectiveOutput", 0.0];
private _pedal      = _heli getVariable ["fza_sfmplus_pedalLeftRight",   0.0];
private _ftPedal    = _heli getVariable ["fza_ah64_forceTrimPosPedal",   0.0];
private _rtrRPM     = _heli getVariable ["fza_sfmplus_rtrRPM",          0.0];

// ── Effective values (getInterpInput logic) ──────────────────────────────────
private _effPitch = if (_cyclicFwd  == 0) then { _ftPitch } else {
    _ftPitch + ((if (_cyclicFwd  > 0) then { 1.0 } else { -1.0 }) - _ftPitch) * abs(_cyclicFwd)
};
private _effRoll  = if (_cyclicBank == 0) then { _ftRoll  } else {
    _ftRoll  + ((if (_cyclicBank > 0) then { 1.0 } else { -1.0 }) - _ftRoll)  * abs(_cyclicBank)
};
private _effPedal = if (_pedal == 0) then { _ftPedal } else {
    _ftPedal + ((if (_pedal > 0) then { 1.0 } else { -1.0 }) - _ftPedal) * abs(_pedal)
};

// ── HeliSim rotor spin ───────────────────────────────────────────────────────
#define MR_REVS_PER_SEC 4.817
#define TR_REVS_PER_SEC 21.5
private _prevRotorPhase = _heli getVariable ["fza_anim_rotorPhase", 0];
private _rotorPhase = _prevRotorPhase + MR_REVS_PER_SEC * _rtrRPM * diag_deltaTime;
if (_rotorPhase >= 10000) then { _rotorPhase = _rotorPhase - floor(_rotorPhase); };
_heli setVariable ["fza_anim_rotorPhase", _rotorPhase];
_heli animateSource ["rotorHUser", _rotorPhase, true];

// Tail rotor spins at TR_REVS_PER_SEC (same transmission, 4.46× MR ratio)
private _prevTailPhase = _heli getVariable ["fza_anim_tailRotorPhase", 0];
private _tailPhase = _prevTailPhase + TR_REVS_PER_SEC * _rtrRPM * diag_deltaTime;
if (_tailPhase >= 10000) then { _tailPhase = _tailPhase - floor(_tailPhase); };
_heli setVariable ["fza_anim_tailRotorPhase", _tailPhase];
_heli animateSource ["rotorVUser", _tailPhase, true];

// ── Model RPM animation source ──────────────────────────────────────────────
[_heli, "mainRotorRPMUser", _rtrRPM, true] call fza_anim_fnc_updateAnimations;

private _swashTns = (_collective * 2.0) - 1.0;
[_heli, "swashplate_up_tns", _swashTns, true] call fza_anim_fnc_updateAnimations;
[_heli, "swashplate_dn_tns", _swashTns, true] call fza_anim_fnc_updateAnimations;
[_heli, "mr_act_tns",        _swashTns, true] call fza_anim_fnc_updateAnimations;

// ── Main rotor swashplate – tilt ─────────────────────────────────────────────
[_heli, "swashplate_up_pitch", _effPitch, true] call fza_anim_fnc_updateAnimations;
[_heli, "swashplate_dn_pitch", _effPitch, true] call fza_anim_fnc_updateAnimations;
[_heli, "swashplate_up_bank",  _effRoll,  true] call fza_anim_fnc_updateAnimations;
[_heli, "swashplate_dn_bank",  _effRoll,  true] call fza_anim_fnc_updateAnimations;

[_heli, "swup_arm1",    _effPitch,  true] call fza_anim_fnc_updateAnimations;
[_heli, "swup_arm1_t",  _effPitch,  true] call fza_anim_fnc_updateAnimations;
[_heli, "swup_arm2",   -_effRoll,   true] call fza_anim_fnc_updateAnimations;
[_heli, "swup_arm3",   -_effPitch,  true] call fza_anim_fnc_updateAnimations;
[_heli, "swup_arm3_t", -_effPitch,  true] call fza_anim_fnc_updateAnimations;
[_heli, "swup_arm4",    _effRoll,   true] call fza_anim_fnc_updateAnimations;

#define MR_BLUR_THRESHOLD 0.4
private _cyclicBladePct = 0.5;

if (_rtrRPM < MR_BLUR_THRESHOLD) then {
    private _rotorAz   = (_rotorPhase mod 1) * 360;
    #define CYCLIC_PHASE_OFFSET 90
    private _cyclicDir = ([0, 0] getDir [_effRoll, _effPitch]) + CYCLIC_PHASE_OFFSET;
    private _cyclicMag = [vectorMagnitude [_effPitch, _effRoll], 0, 1] call BIS_fnc_clamp;
    [_heli, "blade1_pitch", ([_collective - _cyclicBladePct * _cyclicMag * sin((_rotorAz +  45) - _cyclicDir), -1, 1] call BIS_fnc_clamp), true] call fza_anim_fnc_updateAnimations;
    [_heli, "blade2_pitch", ([_collective - _cyclicBladePct * _cyclicMag * sin((_rotorAz + 135) - _cyclicDir), -1, 1] call BIS_fnc_clamp), true] call fza_anim_fnc_updateAnimations;
    [_heli, "blade3_pitch", ([_collective - _cyclicBladePct * _cyclicMag * sin((_rotorAz + 225) - _cyclicDir), -1, 1] call BIS_fnc_clamp), true] call fza_anim_fnc_updateAnimations;
    [_heli, "blade4_pitch", ([_collective - _cyclicBladePct * _cyclicMag * sin((_rotorAz + 315) - _cyclicDir), -1, 1] call BIS_fnc_clamp), true] call fza_anim_fnc_updateAnimations;
} else {
    // Blur state: uniform collective pitch (blades not visible individually)
    [_heli, "blade1_pitch", _collective, true] call fza_anim_fnc_updateAnimations;
    [_heli, "blade2_pitch", _collective, true] call fza_anim_fnc_updateAnimations;
    [_heli, "blade3_pitch", _collective, true] call fza_anim_fnc_updateAnimations;
    [_heli, "blade4_pitch", _collective, true] call fza_anim_fnc_updateAnimations;
};

// ── Tail rotor ───────────────────────────────────────────────────────────────
// trsw: model minValue=-5, maxValue=5 → pedal -1…+1 maps to -5…+5
[_heli, "trsw",           _effPedal * 5, true] call fza_anim_fnc_updateAnimations;
[_heli, "tr_blade1_pitch", -_effPedal,    true] call fza_anim_fnc_updateAnimations;
[_heli, "tr_blade2_pitch", _effPedal,    true] call fza_anim_fnc_updateAnimations;
[_heli, "tr_blade3_pitch", _effPedal,    true] call fza_anim_fnc_updateAnimations;
[_heli, "tr_blade4_pitch", -_effPedal,    true] call fza_anim_fnc_updateAnimations;
