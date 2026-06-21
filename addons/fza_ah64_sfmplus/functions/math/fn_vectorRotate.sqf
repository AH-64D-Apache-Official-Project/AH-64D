params ["_inVec","_p", "_r", "_y"];

private _sinP = sin _p;
private _sinY = sin _y;
private _sinR = sin _r;

private _cosP = cos _p;
private _cosY = cos _y;
private _cosR = cos _r;

private _rotMat =
[
 [ _cosR * _cosY + _sinR * _sinP * _sinY, -_cosR * _sinY + _sinR * _sinP * _cosY,  _sinR * _cosP ]
,[ _cosP * _sinY,                          _cosP * _cosY, -_sinP                                 ]
,[-_sinR * _cosY + _cosR * _sinP * _sinY,  _sinR * _sinY + _cosR * _sinP * _cosY,  _cosR * _cosP ]
];

private _outVec = _rotMat matrixMultiply [[_inVec select 0],[_inVec select 1],[_inVec select 2]];
_outVec         = [_outVec # 0 # 0, _outVec # 1 # 0, _outVec # 2 # 0];

_outVec;
