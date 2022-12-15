params ["_heli", "_mastPitch_deg", "_mastRoll_deg"];

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

[_u_s, _v_s, _w_s];