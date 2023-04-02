params ["_heli", "_engParams"];

_engParams params ["_engContPwr", "_engPwrTurRPM", "_engGndIdleRPMSetPoint", "_engFltIdleRPMSetPoint", "_engFlyRPMSetPoint", "_engGndIdleTqSetPoint", "_engFlyTqSetPoint"];

private _refRPM     = _engPwrTurRPM * _engFlyRPMSetPoint;
private _refTq      = (_engContPwr / 0.001) / 0.105 / _refRPM;

//Torque
private _gndIdleTq  = _refTq * _engGndIdleTqSetPoint;
private _fltIdleTq  = 0.0;
private _flyTq      = _refTq * _engFlyTqSetPoint;

//Gas Generator (Ng) RPM
private _startNg    = 0.243;
private _idleNg     = 0.679;
private _flyNg      = 0.834;
private _maxNg      = 1.051;

//Power Turbine (Np) RPM
private _gndIdleNp = _refRPM * _engGndIdleRPMSetPoint;
private _fltIdleNp = _refRPM * _engFltIdleRPMSetPoint;
private _flyNp     = _refRPM * _engFlyRPMSetPoint;

[_refTq, _gndIdleTq, _fltIdleTq, _flyTq, _startNg, _idleNg, _flyNg, _maxNg, _gndIdleNp, _fltIdleNp, _flyNp];