params ["_heli", "_engParams"];

_engParams params ["_engContPwr", "_engPwrTurRPM", "_engGndIdleRPMSetPoint", "_engFltIdleRPMSetPoint", "_engFlyRPMSetPoint", "_engGndIdleTqSetPoint", "_engFlyTqSetPoint"];

private _refRPM     = _engPwrTurRPM * _engFlyRPMSetPoint;
private _refTq      = (_engContPwr / 0.001) / 0.105 / _refRPM;

//Torque
private _gndIdleTq  = _refTq * _engGndIdleTqSetPoint;
private _fltIdleTq  = 0.0;
private _flyTq      = _refTq * _engFlyTqSetPoint;

//RPM
private _gndIdleRPM = _refRPM * _engGndIdleRPMSetPoint;
private _fltIdleRPM = _refRPM * _engFltIdleRPMSetPoint;
private _flyRPM     = _refRPM * _engFlyRPMSetPoint;

[_refTq, _gndIdleTq, _fltIdleTq, _flyTq, _gndIdleRPM, _fltIdleRPM, _flyRPM];