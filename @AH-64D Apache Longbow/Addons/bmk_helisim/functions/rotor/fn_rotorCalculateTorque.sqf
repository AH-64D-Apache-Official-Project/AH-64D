params ["_heli", "_CT", "_rotorParams", "_rho", "_omegaR", "_mu", "_thrust", "_lambda", "_H"];

_rotorParams params ["_a", "_b", "_R", "_c", "_theta1_deg", "_m", "_eR", "_e", "_gearRatio", "_Ib", "_s"];

//From "Bramwell's Helicopter Dynamics", second edition, eqn 3.43 and 3.44
//Replaces SH79 eqn 36 (sourced from JSBSim)
private _deltaDrag_0 = 6.0 * _CT / (_a * _s);
private _deltaDrag   = 0.009 + 0.3 * (_deltaDrag_0 * _deltaDrag_0);

private _torque = if (_mu == 0.0) then { 0.0; } else {_rho * _b * _c * _deltaDrag * (_omegaR * _omegaR) * (_R * _R) * (1.0 + 4.5 * (_mu * _mu)) / 8.0 - (_thrust * _lambda + _H * _mu) * _R; };

private _outputTorque = _torque / _gearRatio;

[_torque, _outputTorque];