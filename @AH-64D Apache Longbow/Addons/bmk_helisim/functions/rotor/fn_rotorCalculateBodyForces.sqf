params ["_heli", "_H", "_beta_deg", "_J", "_thrust", "_AIC_deg", "_BIC_deg"];

private _x_s = -_H * (cos _beta_deg) - _J * (sin _beta_deg) + _thrust * (rad _BIC_deg);
private _y_s = -_H * (sin _beta_deg) + _J * (cos _beta_deg) + _thrust * (rad _AIC_deg);
private _z_s = _thrust;

[_x_s, _y_s, _z_s];