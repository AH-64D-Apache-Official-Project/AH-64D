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
fza_sfmplus_gndSpeed = vectorMagnitude [velocityModelSpace _heli select 0, velocityModelSpace _heli select 1];
fza_sfmplus_gndSpeed = round(_gndSpeed * MPS_TO_KNOTS);

private _velWind     = [];

if (_useWind) then {
    _velWind = wind;
} else {
    _velWind = [0.0, 0.0, 0.0];
};

//3D velocity of the aircraft
fza_sfmplus_vel3D            = round(MPS_TO_KNOTS * vectorMagnitude(velocityModelSpace _heli vectorDiff _velWind));
//2D velocity of the aircraft
fza_sfmplus_vel2D            = [round(MPS_TO_KNOTS * ((velocityModelSpace _heli vectorDiff _velWind) select 1)), 0.0, 180.0] call BIS_fnc_clamp;
//Velocity model space
fza_sfmplus_velModelSpace    = velocityModelSpace _heli vectorDiff _velWind;
//Velocity world space
fza_sfmplus_velWorldSpace    = velocity _heli vectorDiff _velWind;
//Climb velocity
fza_sfmplus_velClimb         = (velocity _heli select 2) * MPS_TO_FPM;
//Angular velocity in model space
fza_sfmplus_angVelModelSpace = angularVelocityModelSpace _heli;
//Angular velocity in world space
fza_sfmplus_angVelWorldSpace = angularVelocity _heli;