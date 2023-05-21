params ["_heli"];

private _grav   = [0.0, 0.0, 1.0] vectorMultiply 9.806;
private _velTot = vectorMagnitude ((velocity _heli) vectorAdd _grav);
private _velY   = velocityModelSpace _heli # 0;
private _beta   = if (_velTot == 0.0) then { 0.0; } else { asin (_velY / _velTot); };

_beta;