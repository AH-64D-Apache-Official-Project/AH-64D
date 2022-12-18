params ["_heli", "_engNum", "_deltaTime", "_engInput", "_controlInputs", "_maxTqScalar"];

_engInput      params ["_engContPwr", "_refTq", "_gndIdleRPM", "_fltIdleRPM", "_flyRPM", "_engIdleTqSetPoint", "_engFlyTqSetPoint"];
_controlInputs params ["_collectiveVal", "_cyclicPitchVal", "_cyclicRollVal", "_pedalVal", "_engineThrottleVal"];

private _engState  = _heli getVariable "bmk_helisim_engState" select _engNum;
private _engStart  = _heli getVariable "bmk_helisim_engStart" select _engNum;

private _engThrottlePos      = _heli getVariable "bmk_helisim_engThrottlePos" select _engNum;
private _engThrottleSetPoint = _heli getVariable "bmk_helisim_engThrottleSetPoint" select _engNum;

private _outputRPM = _heli getVariable "bmk_helisim_engineOutputRPM" select _engNum;
private _outputTq  = _heli getVariable "bmk_helisim_engineOutputTq"  select _engNum;

private _idleTq    = _engIdleTqSetPoint * _refTq;
private _flyTq     = _engFlyTqSetPoint  * _refTq;
private _maxTq     = _refTq * _maxTqScalar;

private _baseTq    = _idleTq  + (_flyTq - _idleTq) * (_engineThrottleVal select _engNum);

private _setTq     = _baseTq     + (_maxTq - _baseTq)   * (_engineThrottleVal select _engNum) * _collectiveVal;
private _setRPM    = _gndIdleRPM + (_flyRPM - _gndIdleRPM) * (_engineThrottleVal select _engNum);

switch (_engState) do {
    case "OFF": {
        [_heli, _engNum, _deltaTime, _engState, _engStart, _engThrottlePos, _engThrottleSetPoint, _outputRPM, _outputTq] call bmk_helisim_fnc_engineStateOff;
    };
    case "STARTING": {
        [_heli, _engNum, _deltaTime, _engState, _engStart, _engThrottlePos, _engThrottleSetPoint] call bmk_helisim_fnc_engineStateStart;
    };
    case "ON" : {
        [_heli, _engNum, _deltaTime, _engState, _engThrottlePos, _outputRPM, _collectiveVal, _outputTq, _engContPwr, _setRPM, _setTq, _refTq, _maxTq] call bmk_helisim_fnc_engineStateOn;
    };
};

[_outputTq];