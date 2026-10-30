/* ----------------------------------------------------------------------------
Function: fza_anim_fnc_rotorBlades

Description:
    Shows the solid blades or blanks them for the blur, on this machine, from
    the same rotor phase that shows the blur here (mr_blur_hide in the model
    config). Exactly one of the two is ever visible, whatever order the
    aircraft's state reaches this machine in. Each machine with an interface
    runs it for every Apache; the texture only changes when the phase crosses
    the threshold.

Parameters:
    _heli - The helicopter [Object]

Returns:
    Nothing

Examples:
    [_heli] call fza_anim_fnc_rotorBlades

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_animation\headers\rotor.hpp"

params ["_heli"];

private _blur = (_heli animationSourcePhase "mainRotorRPMUser") >= ROTOR_BLUR_RPM;
if (_blur isEqualTo (_heli getVariable ["fza_anim_bladesBlur", ""])) exitWith {};
_heli setVariable ["fza_anim_bladesBlur", _blur];

private _texture = ["\fza_ah64_model\tex\ex\rtrs_co.paa", ""] select _blur;
_heli setObjectTexture ["mr_blades", _texture];
_heli setObjectTexture ["tr_blades", _texture];
