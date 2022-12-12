params ["_heli", "_engNum", "_deltaTime", "_engInput", "_controlInputs", "_xmsnInputTq", "_maxTqScalar"];

_engInput      params ["_continuousPower", "_refTorque", "_idleRPM", "_flyRPM", "_engineIdleTqPct", "_engineFlyTqPct"];
_controlInputs params ["_collectiveVal", "_cyclicPitchVal", "_cyclicRollVal", "_pedalVal", "_engineThrottleVal"];

private _engState  = _heli getVariable "bmk_helisim_engState" select _engNum;
private _engStart  = _heli getVariable "bmk_helisim_engStart" select _engNum;

private _engThrottlePos      = _heli getVariable "bmk_helisim_engThrottlePos" select _engNum;
private _engThrottleSetPoint = _heli getVariable "bmk_helisim_engThrottleSetPoint" select _engNum;

private _outputRPM = _heli getVariable "bmk_helisim_engineOutputRPM" select _engNum;
private _outputTq  = _heli getVariable "bmk_helisim_engineOutputTq"  select _engNum;

private _idleTq    = _engineIdleTqPct * _refTorque;
private _flyTq     = _engineFlyTqPct  * _refTorque;
private _maxTq     = _refTorque * _maxTqScalar;

private _baseTq    = _idleTq + (_flyTq - _idleTq) * (_engineThrottleVal select _engNum);

private _setTq     = _baseTq + (_maxTq - _baseTq)    * (_engineThrottleVal select _engNum) * _collectiveVal;
private _setRPM    = _idleRPM + (_flyRPM - _idleRPM) * (_engineThrottleVal select _engNum);

systemChat format ["_collectiveVal = %1", _collectiveVal];

switch (_engState) do {
    case "OFF": {
        [_heli, _engNum, _deltaTime, _engState, _engStart, _engThrottlePos, _engThrottleSetPoint, _outputRPM, _outputTq] call bmk_helisim_fnc_engineStateOff;
    };
    case "STARTING": {
        [_heli, _engNum, _deltaTime, _engState, _engStart, _engThrottlePos, _engThrottleSetPoint] call bmk_helisim_fnc_engineStateStart;
    };
    case "ON" : {
        [_heli, _engNum, _deltaTime, _engState, _engThrottlePos, _outputRPM, _collectiveVal, _outputTq, _xmsnInputTq, _continuousPower, _setRPM, _setTq, _maxTq] call bmk_helisim_fnc_engineStateOn;
    };
};

systemChat format ["Engine % 1 State %2 -- Start: %3", _engNum, _engState, _engStart];

[_outputTq];