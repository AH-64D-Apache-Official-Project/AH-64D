/* ----------------------------------------------------------------------------
Function: fza_anim_fnc_controlsAnim

Description:
    Drives the pilot stick (cyclic) and collective lever 3D animations.

    Uses the same getInterpInput interpolation as the flight model:
      cyclic = 0   → model at FT trim position (released spring)
      cyclic = ±1  → model at hard stop
      cyclic = mid → lerp between trim and relevant limit by abs(cyclic)

Parameters:
    _heli - The helicopter object [Object]

Returns:
    Nothing

Author:
    FZA AH-64D Project
---------------------------------------------------------------------------- */
params ["_heli"];

private _cyclicFwd  = _heli getVariable ["fza_sfmplus_cyclicFwdAft",    0.0];
private _cyclicBank = _heli getVariable ["fza_sfmplus_cyclicLeftRight",  0.0];
private _ftPitch    = _heli getVariable ["fza_ah64_forceTrimPosPitch",   0.0];
private _ftRoll     = _heli getVariable ["fza_ah64_forceTrimPosRoll",    0.0];
private _collective = _heli getVariable ["fza_sfmplus_collectiveOutput", 0.0];

// Replicate fza_sfmplus_fnc_getInterpInput(_cyclic, _ftTrim)
private _effPitch = if (_cyclicFwd  == 0) then { _ftPitch } else {
    _ftPitch + ((if (_cyclicFwd  > 0) then { 1.0 } else { -1.0 }) - _ftPitch) * abs(_cyclicFwd)
};
private _effRoll  = if (_cyclicBank == 0) then { _ftRoll  } else {
    _ftRoll  + ((if (_cyclicBank > 0) then { 1.0 } else { -1.0 }) - _ftRoll)  * abs(_cyclicBank)
};

[_heli, "plt_cyclic_pitch", _effPitch,   8] call fza_anim_fnc_updateAnimations;
[_heli, "plt_cyclic_bank",  _effRoll,    8] call fza_anim_fnc_updateAnimations;
[_heli, "plt_collective",   _collective, 8] call fza_anim_fnc_updateAnimations;
