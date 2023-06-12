params ["_heli", "_engNum", "_deltaTime", "_refTq"];

private _idleTq   = 0.06 * _refTq;
private _flyTq    = 0.18 * _refTq;

private _outputTq = _heli getVariable "fza_sfmplus_simpleEngOutputTq" select _engNum;

private _engPwrLvrState = _heli getVariable "fza_sfmplus_engPowerLeverState" select _engNum;
private _throttlePos = 0.0;
if (_engPwrLvrState in ["OFF", "IDLE"]) then {
    _throttlePos = 0.0;
} else {
    _throttlePos = 1.0;
};

private _baseTq   = _idleTq + (_flyTq - _idleTq) * _throttlePos;

_outputTq         = [_outputTq, _baseTq, (1 / 8.0) * _deltaTime] call BIS_fnc_lerp;
[_heli, "fza_sfmplus_simpleEngOutputTq", _engNum, _outputTq, true] call fza_fnc_setArrayVariable;

_outputTq;