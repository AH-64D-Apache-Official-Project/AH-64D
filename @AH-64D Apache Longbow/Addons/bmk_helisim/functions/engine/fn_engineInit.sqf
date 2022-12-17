params ["_heli", "_engParams"];

_engParams params ["_engContPwr", "_engPwrTurRPM", "_engGndIdleRPMSetPoint", "_engFltIdleRPMSetPoint", "_engFlyRPMSetPoint", "_engIdleTqSetPoint", "_engFlyTqSetPoint"];

private _engRPM = _engPwrTurRPM * _engFlyRPMSetPoint;
private _refTq  = (_engContPwr / 0.001) / 0.105 / _engRPM;

private _gndIdleRPM = _engRPM * _engGndIdleRPMSetPoint;
private _fltIdleRPM = _engRPM * _engFltIdleRPMSetPoint;
private _flyRPM     = _engRPM * _engFlyRPMSetPoint;

[_engContPwr, _refTq, _gndIdleRPM, _fltIdleRPM, _flyRPM, _engIdleTqSetPoint, _engFlyTqSetPoint];