params ["_heli"];

private _grav   = _heli vectorWorldToModel ([0.0, 0.0,-1.0] vectorMultiply 9.806);
private _velTot = vectorMagnitude ((velocityModelSpace _heli) vectorAdd _grav);
private _velX   = velocityModelSpace _heli # 0;
private _beta   = if (_velTot == 0.0) then { 0.0; } else { asin (_velX / _velTot); };

_beta;