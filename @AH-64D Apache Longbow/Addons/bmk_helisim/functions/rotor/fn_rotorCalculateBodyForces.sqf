params ["_heli", "_dragH", "_beta_deg", "_sideJ", "_thrust", "_AIC_deg", "_BIC_deg"];

private _x_s = -_dragH * (cos _beta_deg) - _sideJ * (sin _beta_deg) + _thrust * (rad _BIC_deg);
private _y_s = -_dragH * (sin _beta_deg) + _sideJ * (cos _beta_deg) + _thrust * (rad _AIC_deg);
private _z_s = -_thrust;

[_x_s, _y_s, _z_s];