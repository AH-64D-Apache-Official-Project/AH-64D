params ["_heli", "_deltaTime", "_rtrNum", "_rotorPos", "_mastPitch_deg", "_mastRoll_deg"];

////////////////////////////////////////////////////////////////////////////////////////////////////
//Linear Velocitis         ///////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

// ARMA               Model 
//
// +Z  +Y                +X
//  +  +                 +
//  | /                 /
//  |/                 / 
//  +-----+ +X        +-----+ +Y
//                    |
//                    |
//                    +
//                   +Z

private _axisX = [1.0, 0.0, 0.0];
private _axisY = [0.0, 1.0, 0.0];
private _axisZ = [0.0, 0.0, 1.0];

private _armaToModelMatrix = [[ 0.0, 1.0, 0.0],
                              [ 1.0, 0.0, 0.0],
                              [ 0.0, 0.0,-1.0]];

private _bodyToShaftMatrix = [[ cos _mastPitch_deg, sin _mastPitch_deg * sin _mastRoll_deg, sin _mastPitch_deg * cos _mastRoll_deg],
                              [                0.0,                      cos _mastRoll_deg,                     -sin _mastRoll_deg],
                              [-sin _mastPitch_deg, cos _mastPitch_deg * sin _mastRoll_deg, cos _mastPitch_deg * cos _mastRoll_deg]];

////////////////////////////////////////////////////////////////////////////////////////////////////
//Linear Velocitis         /////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
private _linVel = [[velocityModelSpace _heli # 0], [velocityModelSpace _heli # 1], [velocityModelSpace _heli # 2]];
_linVel         = _armaToModelMatrix matrixMultiply _linVel;
_linVel         = _bodyToShaftMatrix matrixMultiply _linVel;
_linVel         = [_linVel # 0 # 0, _linVel # 1 # 0, _linVel # 2 # 0];

private _u_s = _linVel # 0;
private _v_s = _linVel # 1;
private _w_s = _linVel # 2;

////////////////////////////////////////////////////////////////////////////////////////////////////
//Angular Velocitis         ////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
private _pitchPrev = _heli getVariable "bmk_helisim_pitchPrev" select _rtrNum;
private _rollPrev  = _heli getVariable "bmk_helisim_rollPrev" select _rtrNum;
private _yawPrev   = _heli getVariable "bmk_helisim_yawPrev" select _rtrNum;

(_heli call bis_fnc_getPitchBank)
    params ["_pitch", "_roll"];
private _yaw = getDir _heli;
//--Convert from degrees to radians
_pitch = rad _pitch; _roll = rad _roll; _yaw = rad _yaw;
//--Calculate angular velocities
private _angVelX = if (_deltaTime == 0) then { 0.0; } else { (_pitchPrev - _pitch) / _deltaTime; };
private _angVelY = if (_deltaTime == 0) then { 0.0; } else { (_rollPrev  - _roll)  / _deltaTime; };
private _angVelZ = if (_deltaTime == 0) then { 0.0; } else { (_yawPrev   - _yaw)   / _deltaTime; };

[_heli, "bmk_helisim_pitchPrev", _rtrNum, _pitch] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_rollPrev",  _rtrNum, _roll] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_yawPrev",   _rtrNum, _yaw] call fza_sfmplus_fnc_setArrayVariable;

private _angVel = [[_angVelX], [_angVelY], [_angVelZ]];
_angVel         = _armaToModelMatrix matrixMultiply _angVel;
_angVel         = _bodyToShaftMatrix matrixMultiply _angVel;
_angVel         = [_angVel # 0 # 0, _angVel # 1 # 0, _angVel # 2 # 0];

private _p_s = _angVel # 0;
private _q_s = _angVel # 1;
private _r_s = _angVel # 2;

//systemChat format ["Rotor %1 Linear Velocity: %2 -- %3 -- %4 Beta: %5", _rtrNum, _u_s toFixed 2, _v_s toFixed 2, _w_s toFixed 2, _beta_deg toFixed 2];
systemChat format ["Rotor %1 Angular Velocity: %2 -- %3 -- %4", _rtrNum, deg _angVelX toFixed 2, deg _angVelY toFixed 2, deg _angVelZ toFixed 2];
systemChat format ["Rotor %1 Angular Velocity: %2 -- %3 -- %4", _rtrNum, deg _p_s toFixed 2, deg _q_s toFixed 2, deg _r_s toFixed 2];

#ifdef __A3_DEBUG__
_axisX = [[_axisX # 0], [_axisX # 1], [_axisX # 2]];
_axisX = _bodyToShaftMatrix matrixMultiply _axisX;
_axisX = _armaToModelMatrix matrixMultiply _axisX;
_axisX = [_axisX # 0 # 0, _axisX # 1 # 0, _axisX # 2 # 0];

_axisY = [[_axisY # 0], [_axisY # 1], [_axisY # 2]];
_axisY = _bodyToShaftMatrix matrixMultiply _axisY;
_axisY = _armaToModelMatrix matrixMultiply _axisY;
_axisY = [_axisY # 0 # 0, _axisY # 1 # 0, _axisY # 2 # 0];

_axisZ = [[_axisZ # 0], [_axisZ # 1], [_axisZ # 2]];
_axisZ = _bodyToShaftMatrix matrixMultiply _axisZ;
_axisZ = _armaToModelMatrix matrixMultiply _axisZ;
_axisZ = [_axisZ # 0 # 0, _axisZ # 1 # 0, _axisZ # 2 # 0];

//Draw model axes
private _colorRed = [1,0,0,1]; private _colorGreen = [0,1,0,1]; private _colorBlue = [0,0,1,1]; private _colorWhite = [1,1,1,1];

DRAW_LINE = {
    params ["_heli", "_p1", "_p2", "_col"];
    drawLine3D [_heli modelToWorldVisual _p1, _heli modelToWorldVisual _p2, _col];
};

[_heli, _rotorPos, _rotorPos vectorAdd _axisX, _colorRed]   call DRAW_LINE;
[_heli, _rotorPos, _rotorPos vectorAdd _axisY, _colorGreen] call DRAW_LINE;
[_heli, _rotorPos, _rotorPos vectorAdd _axisZ, _colorBlue]  call DRAW_LINE;
#endif