params ["_x_s", "_y_s", "_z_s", "_l_s", "_m_s", "_n_s"];

// X, Y, Z = ARMA
// x, y, z = Model
//
// +Zz +Yx
//  +  +
//  | /
//  |/
//  +-----+  +Xy   Axes
private _modelToArmaMatrix = [[ 0.0, -1.0, 0.0],
                              [ -1.0, 0.0, 0.0],
                              [ 0.0, 0.0, 1.0]];

private _locVel = [[_x_s], [_y_s], [_z_s]];
_locVel         = _modelToArmaMatrix matrixMultiply _locVel;

private _out_x = _locVel # 0 # 0;
private _out_y = _locVel # 1 # 0;
private _out_z = _locVel # 2 # 0;

private _locAngVel = [[_l_s], [_m_s], [_n_s]];
_locAngVel         = _modelToArmaMatrix matrixMultiply _locAngVel;

private _out_l = _locAngVel # 0 # 0;
private _out_m = _locAngVel # 1 # 0;
private _out_n = _locAngVel # 2 # 0;

[_out_x, _out_y, _out_z, _out_l, _out_m, _out_n];