params ["_heli", "_Hdrag", "_beta_deg", "_Jside", "_thrust", "_AIC_deg", "_BIC_deg"];

private _x_s = -_Hdrag * (cos _beta_deg) - _Jside * (sin _beta_deg) + _thrust * (rad _BIC_deg);
private _y_s = -_Hdrag * (sin _beta_deg) + _Jside * (cos _beta_deg) + _thrust * (rad _AIC_deg);
private _z_s = -_thrust;

[_x_s, _y_s, _z_s];