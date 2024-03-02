/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_calculateAlphaAndBeta

Description:
    Calculates and returns _alpha (angle of attack) and _beta (sideslip) for the
    helicopter. 

    Reference: 
    https://www.mathworks.com/help/aeroblks/incidencesideslipairspeed.html
    https://trace.tennessee.edu/cgi/viewcontent.cgi?referer=&httpsredir=1&article=5851&context=utk_gradthes
    
Parameters:
    _heli - The apache helicopter to check.

Returns:
    _alpha (angle of attack) in degrees
    _beta (sideslip) in degrees

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

#include "\fza_ah64_sfmplus\headers\core.hpp"

//Gravity in model space
//private _grav     = [[0.0, 0.0, -9.806], -getDir _heli, 1] call BIS_fnc_rotateVector3D;
//private _gravX    = _grav # 0;
//private _gravY    = _grav # 1;
//private _gravZ    = _grav # 2;
//Helicopter velocity in model space
private _heliVel  = velocityModelSpace _heli;
private _heliVelX = _heliVel # 0 + EPSILON;
private _heliVelY = _heliVel # 1 + EPSILON;
private _heliVelZ = _heliVel # 2 + EPSILON;//(_heliVel # 2) * -1.0;
//The total velocity of the helicopter in model space
//private _totVel   = [_gravX, _gravY, _gravZ] vectorAdd [_heliVelX, _heliVelY, _heliVelZ];
//private _totVelX  = _totVel # 0;
//private _totVelY  = _totVel # 1;
//private _totVelZ  = _totVel # 2;

//Alpha is the angle between the helicopters forward velocity and vertical velocity
private _alpha    = if (_heliVelY == 0) then { 0.0; } else { atan (_heliVelZ / _heliVelY); };
//Beta, or sideslip, is the difference betwen the helicopters sideward velocity and the total velocity
private _beta     = asin (_heliVelX / sqrt(vectorMagnitude [_heliVelX, _heliVelY, _heliVelZ]));

systemChat format ["Beta = %1", _beta];

[_alpha, _beta];