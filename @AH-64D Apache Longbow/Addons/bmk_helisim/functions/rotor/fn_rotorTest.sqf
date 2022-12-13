params ["_heli", "_rtrNum", "_rotorPos", "_mastPitch_deg", "_mastRoll_deg"];

private _colorRed = [1,0,0,1]; private _colorGreen = [0,1,0,1]; private _colorBlue = [0,0,1,1]; private _colorWhite = [1,1,1,1];

DRAW_LINE = {
    params ["_heli", "_p1", "_p2", "_col"];
    drawLine3D [_heli modelToWorldVisual _p1, _heli modelToWorldVisual _p2, _col];
};

// X, Y, Z = ARMA
// x, y, z = Model
//
// +Zz +Yx
//  +  +
//  | /
//  |/
//  +-----+  +Xy   Axes
private _vecX = [1.0, 0.0, 0.0];
private _vecY = [0.0, 1.0, 0.0];
private _vecZ = [0.0, 0.0, 1.0];

private _armaToModelMatrix = [[ 0.0, 1.0, 0.0],
                              [ 1.0, 0.0, 0.0],
                              [ 0.0, 0.0,-1.0]];

private _bodyToShaftMatrix = [[ cos _mastPitch_deg, sin _mastPitch_deg * sin _mastRoll_deg, sin _mastPitch_deg * cos _mastRoll_deg],
                              [                0.0,                      cos _mastRoll_deg,                     -sin _mastRoll_deg],
                              [-sin _mastPitch_deg, cos _mastPitch_deg * sin _mastRoll_deg, cos _mastPitch_deg * cos _mastRoll_deg]];

private _locVel = [[velocityModelSpace _heli # 0], [velocityModelSpace _heli # 1], [velocityModelSpace _heli # 2]];
_locVel         = _armaToModelMatrix matrixMultiply _locVel;
_locVel         = _bodyToShaftMatrix matrixMultiply _locVel;
_locVel         = [_locVel # 0 # 0, _locVel # 1 # 0, _locVel # 2 # 0];

private _u_s = _locVel # 0;
private _v_s = _locVel # 1;
private _w_s = _locVel # 2;

private _beta_deg = _v_s atan2 _u_s;

systemChat format ["Rotor %1 Local Velocity: %2 -- %3 -- %4 Beta: %5", _rtrNum, _u_s toFixed 2, _v_s toFixed 2, _w_s toFixed 2, _beta_deg toFixed 2];

_vecX = [[_vecX # 0], [_vecX # 1], [_vecX # 2]];
_vecX = _bodyToShaftMatrix matrixMultiply _vecX;
_vecX = _armaToModelMatrix matrixMultiply _vecX;
_vecX = [_vecX # 0 # 0, _vecX # 1 # 0, _vecX # 2 # 0];

_vecY = [[_vecY # 0], [_vecY # 1], [_vecY # 2]];
_vecY = _bodyToShaftMatrix matrixMultiply _vecY;
_vecY = _armaToModelMatrix matrixMultiply _vecY;
_vecY = [_vecY # 0 # 0, _vecY # 1 # 0, _vecY # 2 # 0];

_vecZ = [[_vecZ # 0], [_vecZ # 1], [_vecZ # 2]];
_vecZ = _bodyToShaftMatrix matrixMultiply _vecZ;
_vecZ = _armaToModelMatrix matrixMultiply _vecZ;
_vecZ = [_vecZ # 0 # 0, _vecZ # 1 # 0, _vecZ # 2 # 0];

#ifdef __A3_DEBUG__
//Draw the force vector
[_heli, _rotorPos, _rotorPos vectorAdd _vecX, _colorRed]   call DRAW_LINE;
[_heli, _rotorPos, _rotorPos vectorAdd _vecY, _colorGreen] call DRAW_LINE;
[_heli, _rotorPos, _rotorPos vectorAdd _vecZ, _colorBlue]  call DRAW_LINE;
#endif