/* ----------------------------------------------------------------------------
Function: fza_fnc_calculateAlphaAndBeta

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

//Gravity in model space
private _grav     = _heli vectorWorldToModel ([0.0, 0.0,-1.0] vectorMultiply 9.806);
private _gravX    = _grav # 0;
private _gravY    = _grav # 1;
private _gravZ    = _grav # 2;
//Helicopter velocity in model space
private _heliVel  = velocityModelSpace _heli;
private _heliVelX = _heliVel # 0;
private _heliVelY = _heliVel # 1;
private _heliVelZ = (_heliVel # 2) * -1.0;
//The total velocity of the helicopter in model space
private _totVel   = [_gravX, _gravY, _gravZ] vectorAdd [_heliVelX, _heliVelY, _heliVelZ];
private _totVelX  = _totVel # 0;
private _totVelY  = _totVel # 1;
private _totVelZ  = _totVel # 2;

//Alpha is the angle between the helicopters forward velocity and vertical velocity
private _alpha    = if (_totVelY == 0) then { 0.0; } else { atan (_totVelZ / _totVelY); };
//Beta, or sideslip, is the difference betwen the helicopters sideward velocity and the total velocity
private _beta     = if ((vectorMagnitude _totVel) == 0.0) then { 0.0; } else { asin (_totVelX / (vectorMagnitude _totVel)); };

[_alpha, _beta];