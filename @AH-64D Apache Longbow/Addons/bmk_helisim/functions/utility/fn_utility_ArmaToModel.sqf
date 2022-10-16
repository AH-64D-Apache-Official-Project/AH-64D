params ["_heli", "_mastPitch", "_mastRoll"];

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
                              [ 0.0, 0.0, 1.0]];

private _bodyToShaftMatrix = [[ cos _mastPitch, sin _mastPitch * sin _mastRoll, sin _mastPitch * cos _mastRoll],
                              [            0.0,                  cos _mastRoll,                 -sin _mastRoll],
                              [-sin _mastPitch, cos _mastPitch * sin _mastRoll, cos _mastPitch * cos _mastRoll]];

private _locVel = [[velocityModelSpace _heli # 0], [velocityModelSpace _heli # 1], [velocityModelSpace _heli # 2]];
_locVel         = _armaToModelMatrix matrixMultiply _locVel;
_locVel         = _bodyToShaftMatrix matrixMultiply _locVel;

[_locVel # 0 # 0, _locVel # 1 # 0, _locVel # 2 # 0];