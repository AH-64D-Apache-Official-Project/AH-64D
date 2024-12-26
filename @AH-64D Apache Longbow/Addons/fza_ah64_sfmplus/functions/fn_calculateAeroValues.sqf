/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_calculateAeroValues

Description:
    Calculates and returns _alpha (angle of attack) and _beta_g (sideslip) for the
    helicopter. 

    Reference: 
    https://www.mathworks.com/help/aeroblks/incidencesideslipairspeed.html
    https://trace.tennessee.edu/cgi/viewcontent.cgi?referer=&httpsredir=1&article=5851&context=utk_gradthes
    
Parameters:
    _heli - The apache helicopter to check.

Returns:
    _alpha (angle of attack) in degrees
    _beta_g (sideslip) in degrees
    _gamma (flight path angle) in degrees

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

#include "\fza_ah64_sfmplus\headers\core.hpp"

([_heli, fza_ah64_sfmplusEnableWind] call fza_sfmplus_fnc_getVelocities)
    params [ 
             "_gndSpeed"
           , "_vel2D"
           , "_vel3D"
           , "_vertVel"
           , "_velModelSpace"
           , "_angVelModelSpace"
           , "_velWorldSpace"
           , "_angVelWorldSpace"
           ];

//Gravity in model space
private _curAtt   = _heli call BIS_fnc_getPitchBank;
private _curPitch = _curAtt # 0;
private _curRoll  = _curAtt # 1;

private _grav     = [[0.0, 0.0, -9.806], _curRoll, 1] call BIS_fnc_rotateVector3D;//_heli vectorWorldToModel ([0.0, 0.0,-1.0] vectorMultiply 9.806);
private _gravX    = _grav # 0;
private _gravY    = _grav # 1;
private _gravZ    = _grav # 2;
//Helicopter velocity in model space
private _modelVelX = _velModelSpace # 0;
private _modelVelY = _velModelSpace # 1;
private _modelVelZ = _velModelSpace # 2;//(_heliVel # 2) * -1.0;
//Helicopter velocity in world space
private _velX = _velWorldSpace # 0;
private _velY = _velWorldSpace # 1;
private _velZ = _velWorldSpace # 2;
//The total velocity of the helicopter in model space
private _totVel   = [_modelVelX, _modelVelY, _modelVelZ] vectorAdd [_gravX, _gravY, _gravZ];
private _totVelX  = _totVel # 0;
private _totVelY  = _totVel # 1;
private _totVelZ  = _totVel # 2;

//Alpha is the angle between the helicopters forward velocity and vertical velocity
private _alpha    = if (_totVelY == 0) then { 0.0; } else { atan (_totVelZ / _totVelY); };
//Beta, or sideslip, is the difference betwen the helicopters sideward velocity and the total velocity
private _beta_deg = if ((vectorMagnitude _totVel) == 0.0) then { 0.0; } else { asin (_totVelX / (vectorMagnitude _totVel)); };
private _beta_g   = ((vectorMagnitude _totVel) * (sin _beta_deg)) / GRAVITY;

//private _beta_degAccel = (-9.806 * (tan _beta_deg)) / 9.8
//systemChat format ["Sidelsip = %1 - Beta = %2", _beta_deg, _beta_g];
//Gamme, or flight path angle, is the angle between
private _gamma    = if (_modelVelY == 0) then { 0.0; } else { asin (_velZ / _modelVelY); };

_heli setVariable ["fza_sfmplus_aero_alpha",    _alpha,    true];
_heli setVariable ["fza_sfmplus_aero_beta_deg", _beta_deg, true];
_heli setVariable ["fza_sfmplus_aero_beta_g",   _beta_g,   true];
_heli setVariable ["fza_sfmplus_aero_gamma",    _gamma,    true];