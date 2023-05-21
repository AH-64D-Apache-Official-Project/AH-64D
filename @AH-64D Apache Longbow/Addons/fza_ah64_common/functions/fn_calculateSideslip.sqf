params ["_heli"];

private _grav   = [0.0, 0.0, 1.0] vectorMultiply 9.806;
private _velTot = vectorMagnitude ((velocity _heli) vectorAdd _grav);
private _velY   = velocityModelSpace _heli # 0;
private _beta   = if (_velTot == 0.0) then { 0.0; } else { asin (_velY / _velTot); };

systemChat format ["Beta = %1 -- %2", _beta toFixed 2, (_beta / 9.806) toFixed 2];
systemChat format ["VelX = %1 -- VelY = %2 -- VelZ = %3", (velocity _heli # 0) toFixed 2
                                                        , (velocity _heli # 1) toFixed 2
                                                        , ((velocity _heli vectorAdd _grav) # 2) toFixed 2];

_beta;