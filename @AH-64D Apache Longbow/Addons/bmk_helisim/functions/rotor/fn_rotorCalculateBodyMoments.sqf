params ["_heli", "_a1_deg", "_beta_deg", "_b1_deg", "_AIC_deg", "_BIC_deg", "_omega", "_rotorParams", "_torque"];

_rotorParams params ["_a", "_b", "_R", "_c", "_theta1_deg", "_m", "_eR", "_e", "_gearRatio", "_Ib", "_s"];

private _a1s = -(rad _BIC_deg);//(rad _a1_deg) * (cos _beta_deg) + (rad _b1_deg) * (sin _beta_deg) - (rad _BIC_deg); //-(rad _BIC_deg);
private _b1s =  (rad _AIC_deg);//(rad _b1_deg) * (cos _beta_deg) - (rad _a1_deg) * (sin _beta_deg) + (rad _AIC_deg); //(rad _AIC_deg);

private _l_s = (1.0 / 2.0) * _e * _b * (_omega * _omega) * _Ib * _b1s;
private _m_s = (1.0 / 2.0) * _e * _b * (_omega * _omega) * _Ib * _a1s;
private _n_s = 0.0;//_torque; //Currently 0, will need to be _torque * _dir when tail rotor is in and working

[_l_s, _m_s, _n_s];