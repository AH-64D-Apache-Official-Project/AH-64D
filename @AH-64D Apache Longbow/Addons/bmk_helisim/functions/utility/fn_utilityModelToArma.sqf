params ["_mastPitch_deg", "_mastRoll_deg", "_x_s", "_y_s", "_z_s", "_l_s", "_m_s", "_n_s"];

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

private _armaToModelMatrix = [[ 0.0, 1.0, 0.0]
                             ,[ 1.0, 0.0, 0.0]
                             ,[ 0.0, 0.0,-1.0]];
private _modelToArmaMatrix = matrixTranspose _armaToModelMatrix;

private _bodyToShaftMatrix = [[ cos _mastPitch_deg, sin _mastPitch_deg * sin _mastRoll_deg, sin _mastPitch_deg * cos _mastRoll_deg]
                             ,[                0.0,                      cos _mastRoll_deg,                     -sin _mastRoll_deg]
                             ,[-sin _mastPitch_deg, cos _mastPitch_deg * sin _mastRoll_deg, cos _mastPitch_deg * cos _mastRoll_deg]];
private _shaftToBodyMatrix = matrixTranspose _bodyToShaftMatrix;


private _bodyForces = [[_x_s], [_y_s], [_z_s]];
_bodyForces         = _modelToArmaMatrix matrixMultiply _bodyForces;
_bodyForces         = _shaftToBodyMatrix matrixMultiply _bodyForces;

private _out_x = _bodyForces # 0 # 0;
private _out_y = _bodyForces # 1 # 0;
private _out_z = _bodyForces # 2 # 0;

private _bodyMoments = [[_l_s], [_m_s], [_n_s]];
_bodyMoments         = _modelToArmaMatrix matrixMultiply _bodyMoments;
_bodyMoments         = _shaftToBodyMatrix matrixMultiply _bodyMoments;

private _out_l = _bodyMoments # 0 # 0;
private _out_m = _bodyMoments # 1 # 0;
private _out_n = _bodyMoments # 2 # 0;

[_out_x, _out_y, _out_z, _out_l, _out_m, _out_n];