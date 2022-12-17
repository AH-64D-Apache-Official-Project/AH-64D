params ["_heli", "_u_s", "_v_s", "_w_s", "_AIC_deg", "_BIC_deg"];

private _beta_deg = _v_s atan2 _u_s;

private _u_w = _u_s * (cos _beta_deg) + _v_s * (sin _beta_deg);
private _v_w = 0.0;
private _w_w = _w_s - (rad _BIC_deg) * _u_s - (rad _AIC_deg) * _v_s;

[_beta_deg, _u_w, _v_w, _w_w];