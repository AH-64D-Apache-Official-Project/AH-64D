/* ----------------------------------------------------------------------------
Function: fza_fnc_avionicsSlipIndicator

Description:
    Updates *fza_ah64_dps* and *fza_ah64_sideslip* to be the degrees per second and slip for the respective helicopter.

    The first reading after switching helicopter / taking a reading for a while will always be inaccurate as these are both calculated as the difference between two readings of *direction*

Parameters:
    _heli - The apache helicopter to check.

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_fnc_avionicsSlipIndicator
    // fza_ah64_dps => 5
    // fza_ah64_sideslip => 3
    ---

Author:
    Unknown
---------------------------------------------------------------------------- */
params["_heli"];

if (!(player in _heli)) exitWith {};

private _beta_g = _heli getVariable "bmkhs_aero_beta_g";

//DISPLAY SIGN ONLY - never negate bmkhs_aero_beta_g upstream; the heading hold,
//auto-pedal and auto-tuner all depend on its raw sign (+ = accel right).
//Hover has no lateral accel, so the ball is a pendulum hanging to the low side (AH-64 hovers
//left-side-low). In forward flight it is a correction cue - "step on the ball".
private _spdKt = (vectorMagnitude velocity _heli) * 1.94384;
private _w     = ((_spdKt - 10.0) / 20.0) min 1.0 max 0.0;   //-1 below 10kt, +1 above 30kt
private _beta_g_display = _beta_g * (-1.0 + (2.0 * _w));

//Full deflection at +-0.15 g lateral.
private _fullScaleG = 0.15;
fza_ah64_sideslip = [_beta_g_display / _fullScaleG, -1.0, 1.0] call BIS_fnc_clamp;
