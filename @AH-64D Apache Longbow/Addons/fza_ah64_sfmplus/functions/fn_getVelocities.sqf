/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_rotorMain

Description:
    Simple rotor provides a simple, grounded in reality simulation of a
    helicopters rotor. Translational Lift, Ground Effect and Vortex Ring State
    are all simulated. This is an implementation of NASA Technical Paper 1285
    bu J.D. Shaughnessy with simplifications sourced from JSBSim.

Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    _gndSpeed, kts
    _vel2D, kts, simulates velocity from pitot/static sources
    _vel3D, kts, simulates velocity from an air data sensor
    _velModelSpace, m/s, unified local velocity for the simulation to use
    _velWorldSpace, m/s, unified velocity for the simulation to use

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_useWind"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

private _gndSpeedVec   = [velocityModelSpace _heli select 0, velocityModelSpace _heli select 1];
private _gndSpeed      = round(MPS_TO_KNOTS * (vectorMagnitude _gndSpeedVec));

private _vel3D         = 0.0;
private _vel2D         = 0.0;
private _velModelSpace = [];
private _velWorldSpace = [];
private _velWind       = [];

if (_useWind) then {
    _velWind = wind;
} else {
    _velWind = [0.0, 0.0, 0.0];
};

_vel3D         = round(MPS_TO_KNOTS * vectorMagnitude(velocityModelSpace _heli vectorDiff _velWind));
_vel2D         = round(MPS_TO_KNOTS * ((velocityModelSpace _heli vectorDiff _velWind) select 1));
_vel2D         = [_vel2D, 0.0, 180.0] call BIS_fnc_clamp;
_velModelSpace = velocityModelSpace _heli vectorDiff _velWind;
_velWorldSpace = velocity _heli vectorDiff _velWind;

private _velVert   = (velocity _heli select 2) * MPS_TO_FPM;

private _angVelModelSpace = angularVelocityModelSpace _heli;
private _angVelWorldSpace = angularVelocity _heli;

[_gndSpeed, _vel2D, _vel3D, _velVert, _velModelSpace, _angVelModelSpace, _velWorldSpace, _angVelModelSpace, _angVelWorldSpace];