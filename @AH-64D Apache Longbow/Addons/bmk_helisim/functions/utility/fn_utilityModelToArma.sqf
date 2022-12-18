params ["_x_s", "_y_s", "_z_s", "_l_s", "_m_s", "_n_s"];

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

private _modelToArmaMatrix = [[ 0.0, 1.0, 0.0],
                              [ 1.0, 0.0, 0.0],
                              [ 0.0, 0.0,-1.0]];

private _bodyForces = [[_x_s], [_y_s], [_z_s]];
_bodyForces         = _modelToArmaMatrix matrixMultiply _bodyForces;

private _out_x = _bodyForces # 0 # 0;
private _out_y = _bodyForces # 1 # 0;
private _out_z = _bodyForces # 2 # 0;

private _bodyMoments = [[_l_s], [_m_s], [_n_s]];
_bodyMoments         = _modelToArmaMatrix matrixMultiply _bodyMoments;

private _out_l = _bodyMoments # 0 # 0;
private _out_m = _bodyMoments # 1 # 0;
private _out_n = _bodyMoments # 2 # 0;

[_out_x, _out_y, _out_z, _out_l, _out_m, _out_n];