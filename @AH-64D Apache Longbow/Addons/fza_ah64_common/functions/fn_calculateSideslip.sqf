params ["_heli"];


private _velTot = vectorMagnitude velocity _heli;
private _velY   = velocityModelSpace _heli # 0;
private _beta   = if (_velTot == 0.0) then { 0.0; } else { asin (_velY / _velTot); };

systemChat format ["Beta = %1 -- %2", _beta, _beta / 9.806];