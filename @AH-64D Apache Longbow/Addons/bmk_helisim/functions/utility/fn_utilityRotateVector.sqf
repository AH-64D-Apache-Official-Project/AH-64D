params ["_inVec", "_wingRot"];

_wingRot 
    params ["_pitch", "_roll"];

private _rotMat = [[ cos _pitch, sin _pitch * sin _roll, sin _pitch * cos _roll]
                  ,[        0.0,              cos _roll,             -sin _roll]
                  ,[-sin _pitch, cos _pitch * sin _roll, cos _pitch * cos _roll]];

private _temp = [[_inVec # 0], [_inVec # 1], [_inVec # 2]];
_temp = _rotMat matrixMultiply _temp;

private _outVec = [_temp # 0 # 0, _temp # 1 # 0, _temp # 2 # 0];

[_outVec];