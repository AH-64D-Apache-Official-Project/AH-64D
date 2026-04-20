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
#include "\fza_ah64_sfmplus\headers\core.hpp"
params["_heli"];

if (!(player in _heli)) exitWith {};

// Slip ball = lateral specific force = (a_lateral_inertial - g_lateral) / g
//
// Using body-frame accelX (d(V_body_x)/dt) is incorrect here because it contains
// a rotation-frame term (ω_z × V_y) that produces false readings in coordinated turns.
// Differentiating world-space velocity and projecting onto the body right axis avoids this.
//
// Result is zero in coordinated flight and deflects proportionally to uncoordinated
// lateral forces, matching a real inclinometer/slip ball instrument.

private _velWorld   = _heli getVariable "fza_sfmplus_velWorldSpace";
private _deltaTime  = _heli getVariable "fza_sfmplus_deltaTime";
private _velPrev    = _heli getVariable "fza_avionics_slipBall_velPrev";

// World-space acceleration via velocity differentiation
private _accelWorld = if (_deltaTime > 0.0001) then {
    (_velWorld vectorDiff _velPrev) vectorMultiply (1 / _deltaTime)
} else {
    [0, 0, 0]
};

// Body right axis in world space (model select 0 = lateral right for this aircraft)
private _rightHat = _heli vectorModelToWorld [1, 0, 0];

// Lateral specific force: inertial lateral acceleration minus gravity's lateral component
// g_lateral = [0,0,-9.806] · rightHat  (gravity pulls toward low side when banked)
private _aLateral = _accelWorld vectorDotProduct _rightHat;
private _gLateral = [0, 0, -GRAVITY] vectorDotProduct _rightHat;

// Normalize: ±1 at ±0.3g — representative full-deflection range for the slip indicator
fza_ah64_sideslip = [(_gLateral - _aLateral) / (GRAVITY * 0.3), -1.0, 1.0] call BIS_fnc_clamp;

_heli setVariable ["fza_avionics_slipBall_velPrev", _velWorld];
