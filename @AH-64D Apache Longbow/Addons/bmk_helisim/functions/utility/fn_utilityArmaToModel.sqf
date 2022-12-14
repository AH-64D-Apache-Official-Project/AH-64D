params ["_heli", "_deltaTime", "_mastPitch_deg", "_mastRoll_deg"];



// X, Y, Z = ARMA
// x, y, z = Model
//
// +Zz +Yx
//  +  +
//  | /
//  |/
//  +-----+  +Xy   Axes
private _armaToModelMatrix = [[ 0.0, 1.0, 0.0],
                              [ 1.0, 0.0, 0.0],
                              [ 0.0, 0.0,-1.0]];

private _bodyToShaftMatrix = [[ cos _mastPitch_deg, sin _mastPitch_deg * sin _mastRoll_deg, sin _mastPitch_deg * cos _mastRoll_deg],
                              [            0.0,                          cos _mastRoll_deg,                     -sin _mastRoll_deg],
                              [-sin _mastPitch_deg, cos _mastPitch_deg * sin _mastRoll_deg, cos _mastPitch_deg * cos _mastRoll_deg]];

private _locVel = [[velocityModelSpace _heli # 0], [velocityModelSpace _heli # 1], [velocityModelSpace _heli # 2]];
_locVel         = _armaToModelMatrix matrixMultiply _locVel;
_locVel         = _bodyToShaftMatrix matrixMultiply _locVel;

private _u_s = _locVel # 0 # 0;
private _v_s = _locVel # 1 # 0;
private _w_s = _locVel # 2 # 0;


private _pitchPrev = _heli getVariable "bmk_helisim_pitchPrev";
private _rollPrev  = _heli getVariable "bmk_helisim_rollPrev";
private _yawPrev   = _heli getVariable "bmk_helisim_yawPrev";

//--Get angular velocities
(_heli call bis_fnc_getPitchBank) params ["_pitch", "_roll"];
private _yaw = getDir _heli;
//--Convert from degrees to radians
_pitch = rad _pitch; _roll = rad _roll; _yaw = rad _yaw;
//--Calculate angular velocities
private _locAngVelX = if (_deltaTime == 0) then { 0.0; } else { (_pitchPrev - _pitch) / _deltaTime; };
private _locAngVelY = if (_deltaTime == 0) then { 0.0; } else { (_rollPrev  - _roll)  / _deltaTime; };
private _locAngVelZ = if (_deltaTime == 0) then { 0.0; } else { (_yawPrev   - _yaw)   / _deltaTime; };

_heli setVariable ["bmk_helisim_pitchPrev", _pitch];
_heli setVariable ["bmk_helisim_rollPrev",  _roll];
_heli setVariable ["bmk_helisim_yawPrev",   _yaw];

private _locAngVel = [[_locAngVelX], [_locAngVelY], [_locAngVelZ]];
_locAngVel         = _armaToModelMatrix matrixMultiply _locAngVel;
_locAngVel         = _bodyToShaftMatrix matrixMultiply _locAngVel;

private _p_s = _locAngVel # 0 # 0;
private _q_s = _locAngVel # 1 # 0;
private _r_s = _locAngVel # 2 # 0;

[_u_s, _v_s, _w_s, _p_s, _q_s, _r_s];