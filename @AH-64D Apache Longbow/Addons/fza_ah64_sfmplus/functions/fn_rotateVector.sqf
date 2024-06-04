params ["_inVec", "_pitchRoll"];

_pitchRoll
    params ["_pitch", "_roll"];

private _outVec = _inVec;

_outVec = [_outVec, [1.0, 0.0, 0.0], _pitch] call fza_sfmplus_fnc_quaternion;
_outVec = [_outVec, [0.0, 1.0, 0.0], _roll]  call fza_sfmplus_fnc_quaternion;

_outVec;