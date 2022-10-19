params ["_heli", "_p_s", "_q_s", "_r_s", "_beta_deg"];

systemChat format ["_p_s: %1 _q_s: %2 _r_s: %3", _p_s, _q_s, _r_s];

//SH79, eqn 30
private _p_w =  _p_s * (cos _beta_deg) + _q_s * (sin _beta_deg);
private _q_w = -_p_s * (sin _beta_deg) + _q_s * (cos _beta_deg);
private _r_w =  _r_s; 

[_p_w, _q_w, _r_w];