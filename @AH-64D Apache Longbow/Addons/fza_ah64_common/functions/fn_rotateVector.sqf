params ["_inVec", "_xAxis", "_yAxis", "_zAxis"];

private _outVec = _inVec;

_outVec = [_outVec, [0.0, 1.0, 0.0], _yAxis] call fza_sfmplus_fnc_quaternion;
_outVec = [_outVec, [1.0, 0.0, 0.0], _xAxis] call fza_sfmplus_fnc_quaternion;
_outVec = [_outVec, [0.0, 0.0, 1.0], _zAxis] call fza_sfmplus_fnc_quaternion;

_outVec;