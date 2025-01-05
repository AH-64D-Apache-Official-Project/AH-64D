/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_getVelocities

Description:

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

//Ground speed
private _gndSpeed        = round(vectorMagnitude [velocityModelSpace _heli select 0, velocityModelSpace _heli select 1] * MPS_TO_KNOTS);

private _velWind = [];

if (_useWind) then {
    _velWind = wind;
} else {
    _velWind = [0.0, 0.0, 0.0];
};

//3D velocity of the aircraft
private _vel3D             = round(MPS_TO_KNOTS * vectorMagnitude(velocityModelSpace _heli vectorDiff _velWind));
//2D velocity of the aircraft
private _vel2D             = [round(MPS_TO_KNOTS * ((velocityModelSpace _heli vectorDiff _velWind) select 1)), 0.0, 180.0] call BIS_fnc_clamp;
//Velocity model space
private _velModelSpace     = velocityModelSpace _heli;
private _velModelSpaceWind = velocityModelSpace _heli vectorDiff _velWind;
//Velocity world space
private _velWorldSpace     = velocity _heli vectorDiff _velWind;
//Climb velocity
private _velClimb          = (velocity _heli select 2) * MPS_TO_FPM;
//Angular velocity in model space
private _angVelModelSpace  = angularVelocityModelSpace _heli;
//Angular velocity in world space
private _angVelWorldSpace  = angularVelocity _heli;

_heli setVariable ["fza_sfmplus_gndSpeed",          _gndSpeed];
_heli setVariable ["fza_sfmplus_vel2D",             _vel3D];
_heli setVariable ["fza_sfmplus_vel3D",             _vel2D];
_heli setVariable ["fza_sfmplus_velModelSpace",     _velModelSpace];
_heli setVariable ["fza_sfmplus_velModelSpaceWind", _velModelSpaceWind];
_heli setVariable ["fza_sfmplus_velWorldSpace",     _velWorldSpace];
_heli setVariable ["fza_sfmplus_velClimb",          _velClimb];
_heli setVariable ["fza_sfmplus_angVelModelSpace",  _angVelModelSpace];
_heli setVariable ["fza_sfmplus_angVelWorldSpace",  _angVelWorldSpace];