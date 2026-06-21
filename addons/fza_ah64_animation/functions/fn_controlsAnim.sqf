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

if (player != currentPilot _heli) exitWith {};

private _cyclicFwd  = _heli getVariable ["fza_sfmplus_cyclicFwdAft",    0.0];
private _cyclicBank = _heli getVariable ["fza_sfmplus_cyclicLeftRight",  0.0];
private _ftPitch    = _heli getVariable ["fza_ah64_forceTrimPosPitch",   0.0];
private _ftRoll     = _heli getVariable ["fza_ah64_forceTrimPosRoll",    0.0];
private _collective = _heli getVariable ["fza_sfmplus_collectiveOutput", 0.0];

private _effPitch = [_cyclicFwd,  _ftPitch] call fza_anim_fnc_getEffInput;
private _effRoll  = [_cyclicBank, _ftRoll]  call fza_anim_fnc_getEffInput;

[_heli, "plt_cyclic_pitch", _effPitch,   8] call fza_anim_fnc_updateAnimations;
[_heli, "plt_cyclic_bank",  _effRoll,    8] call fza_anim_fnc_updateAnimations;
[_heli, "plt_collective",   _collective, 8] call fza_anim_fnc_updateAnimations;
