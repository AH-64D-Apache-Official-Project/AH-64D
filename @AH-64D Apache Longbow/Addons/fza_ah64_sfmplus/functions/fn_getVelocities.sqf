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

//Wind
private _velWind = [];

if (_useWind) then {
    _velWind = wind;
} else {
    _velWind = [0.0, 0.0, 0.0];
};
//Velocity model space
private _velModelSpaceX_avg    = _heli getVariable "fza_sfmplus_velModelSpaceX_avg";
private _velModelSpaceY_avg    = _heli getVariable "fza_sfmplus_velModelSpaceY_avg";
private _velModelSpaceZ_avg    = _heli getVariable "fza_sfmplus_velModelSpaceZ_avg";

private _velModelSpaceX        = velocityModelSpace _heli select 0;
_velModelSpaceX                = [_velModelSpaceX_avg, _velModelSpaceX] call fza_sfmplus_fnc_getSmoothAverage;
private _velModelSpaceY        = velocityModelSpace _heli select 1;
_velModelSpaceY                = [_velModelSpaceY_avg, _velModelSpaceY] call fza_sfmplus_fnc_getSmoothAverage;
private _velModelSpaceZ        = velocityModelSpace _heli select 2;
_velModelSpaceZ                = [_velModelSpaceZ_avg, _velModelSpaceZ] call fza_sfmplus_fnc_getSmoothAverage;
private _velModelSpace         = [_velModelSpaceX, _velModelSpaceY, _velModelSpaceZ] vectorDiff _velWind;
private _velModelSpaceNoWind   = [_velModelSpaceX, _velModelSpaceY, _velModelSpaceZ];
//Ground speed
private _gndSpeed              = round(vectorMagnitude [_velModelSpaceNoWind select 0, _velModelSpaceNoWind select 1] * MPS_TO_KNOTS);
//3D velocity of the aircraft
private _vel3D                 = round(MPS_TO_KNOTS * vectorMagnitude _velModelSpace);
//2D velocity of the aircraft
private _vel2D                 = [round(MPS_TO_KNOTS * (_velModelSpace select 1)), 0.0, 180.0] call BIS_fnc_clamp;
//Velocity world space
private _velWorldSpaceX_avg    = _heli getVariable "fza_sfmplus_velWorldSpaceX_avg";
private _velWorldSpaceY_avg    = _heli getVariable "fza_sfmplus_velWorldSpaceY_avg";
private _velWorldSpaceZ_avg    = _heli getVariable "fza_sfmplus_velWorldSpaceZ_avg";

private _velWorldSpaceX        = velocity _heli select 0;
_velWorldSpaceX                = [_velWorldSpaceX_avg, _velWorldSpaceX] call fza_sfmplus_fnc_getSmoothAverage;
private _velWorldSpaceY        = velocity _heli select 1;
_velWorldSpaceY                = [_velWorldSpaceY_avg, _velWorldSpaceY] call fza_sfmplus_fnc_getSmoothAverage;
private _velWorldSpaceZ        = velocity _heli select 2;
_velWorldSpaceZ                = [_velWorldSpaceZ_avg, _velWorldSpaceZ] call fza_sfmplus_fnc_getSmoothAverage;
private _velWorldSpace         = [_velWorldSpaceX, _velWorldSpaceY, _velWorldSpaceZ];// vectorDiff _velWind;
//Climb velocity
private _velClimb              = (_velWorldSpace select 2) * MPS_TO_FPM;
//Angular velocity in model space
//private _angVelModelSpaceX_avg    = _heli getVariable "fza_sfmplus_angVelModelSpaceX_avg";
//private _angVelModelSpaceY_avg    = _heli getVariable "fza_sfmplus_angVelModelSpaceY_avg";
//private _angVelModelSpaceZ_avg    = _heli getVariable "fza_sfmplus_angVelModelSpaceZ_avg";

private _angVelModelSpaceX     = angularVelocityModelSpace _heli select 0;
//_angVelModelSpaceX             = [_angVelModelSpaceX_avg, _angVelModelSpaceX] call fza_sfmplus_fnc_getSmoothAverage;
private _angVelModelSpaceY     = angularVelocityModelSpace _heli select 1;
//_angVelModelSpaceY             = [_angVelModelSpaceY_avg, _angVelModelSpaceY] call fza_sfmplus_fnc_getSmoothAverage;
private _angVelModelSpaceZ     = angularVelocityModelSpace _heli select 2;
//_angVelModelSpaceZ             = [_angVelModelSpaceZ_avg, _angVelModelSpaceZ] call fza_sfmplus_fnc_getSmoothAverage;
private _angVelModelSpace      = [_angVelModelSpaceX, _angVelModelSpaceY, _angVelModelSpaceZ];
//Angular velocity in world space
private _angVelWorldSpace      = angularVelocity _heli;

_heli setVariable ["fza_sfmplus_gndSpeed",            _gndSpeed];
_heli setVariable ["fza_sfmplus_vel2D",               _vel3D];
_heli setVariable ["fza_sfmplus_vel3D",               _vel2D];
_heli setVariable ["fza_sfmplus_velModelSpace",       _velModelSpace];
_heli setVariable ["fza_sfmplus_velModelSpaceNoWind", _velModelSpaceNoWind];
_heli setVariable ["fza_sfmplus_velWorldSpace",       _velWorldSpace];
_heli setVariable ["fza_sfmplus_velClimb",            _velClimb];
_heli setVariable ["fza_sfmplus_angVelModelSpace",    _angVelModelSpace];
_heli setVariable ["fza_sfmplus_angVelWorldSpace",    _angVelWorldSpace];