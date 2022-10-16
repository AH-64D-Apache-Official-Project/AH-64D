params ["_heli", "_mastPitch", "_mastRoll", "_AIC", "_BIC"];

private _locVel = [_heli, _mastPitch, _mastRoll] call bmk_helisim_fnc_utilityArmaToModel;
private _u_s    = _locVel # 0;
private _v_s    = _locVel # 1;
private _w_s    = _locVel # 2;

private _beta_deg     = _v_s atan2 _u_s;
//if (isNil (str _beta_deg)) then { _beta_deg = 0.0; };
systemChat format ["%1", _beta_deg];

private _u_w = _u_s * (cos _beta_deg) + _v_s * (sin _beta_deg);
private _v_w = 0.0;
private _w_w = _w_s - _BIC * _u_s * _AIC * _v_s;

//if (isNil (str _u_w)) then { _u_w = 0.0; };
//if (isNil (str _v_w)) then { _v_w = 0.0; };
//if (isNil (str _w_w)) then { _w_w = 0.0; };

[_beta_deg, _u_w, _v_w, _w_w];