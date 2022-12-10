params ["_heli", "_deltaTime", "_engNum", "_engineInput", "_controlInputs", "_engOn", "_xmsnInputTq", "_maxTqScalar"];

_engineInput   params ["_continuousPower", "_refTorque", "_idleRPM", "_flyRPM", "_engineIdleTqPct", "_engineFlyTqPct"];
_controlInputs params ["_collectiveVal", "_cyclicPitchVal", "_cyclicRollVal", "_pedalVal", "_engineThrottleVal"];

private _outputRPM = _heli getVariable "bmk_helisim_engineOutputRPM" select _engNum;
private _outputTq  = _heli getVariable "bmk_helisim_engineOutputTq"  select _engNum;

private _setRPM = _idleRPM + (_flyRPM - _idleRPM) * (_engineThrottleVal select _engNum);

private _maxTq  = _refTorque * _maxTqScalar;
private _idleTq = _engineIdleTqPct * _refTorque;
private _flyTq  = _engineFlyTqPct  * _refTorque;

private _baseTq = _idleTq + (_flyTq - _idleTq) * (_engineThrottleVal select _engNum);
private _setTq  = _baseTq + (_maxTq - _baseTq) * (_engineThrottleVal select _engNum) * _collectiveVal;

_outputRPM = if (_xmsnInputTq == 0.0) then { 0.0; } else { (30.0 * (_continuousPower / 0.001)) / (_xmsnInputTq * pi); };
_outputRPM = [_outputRPM, 0.0, _setRPM] call BIS_fnc_clamp;

[_heli, "bmk_helisim_engineOutputRPM", _engNum, _outputRPM] call fza_sfmplus_fnc_setArrayVariable;

if (_engOn) then {
    _outputTq = [_outputTq, _setTq, _deltaTime] call BIS_fnc_lerp;
} else {
    _outputTq = [_outputTq, 0.0, _deltaTime] call BIS_fnc_lerp;
};

_outputTq  = [_outputTq, 0.0, _maxTq] call BIS_fnc_clamp;
[_heli, "bmk_helisim_engineOutputTq", _engNum, _outputTq] call fza_sfmplus_fnc_setArrayVariable;

[_outputRPM, _outputTq];