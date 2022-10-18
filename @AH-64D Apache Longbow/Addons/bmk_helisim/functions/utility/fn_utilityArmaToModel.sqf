params ["_heli", "_mastPitch_deg", "_mastRoll_deg"];

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

[_u_s, _v_s, _w_s];