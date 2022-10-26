params ["_heli", "_continuousPower", "_engineRPM", "_engineIdleRPMPct", "_engineFlyRPMPct", "_engineIdleTqPct", "_engineFlyTqPct"];

private _refTorque = (_continuousPower / 0.001) / 0.105 / _engineRPM;

private _idleRPM   = _engineRPM * _engineIdleRPMPct;
private _flyRPM    = _engineRPM * _engineFlyRPMPct;

[_continuousPower, _refTorque, _idleRPM, _flyRPM, _engineIdleTqPct, _engineFlyTqPct];