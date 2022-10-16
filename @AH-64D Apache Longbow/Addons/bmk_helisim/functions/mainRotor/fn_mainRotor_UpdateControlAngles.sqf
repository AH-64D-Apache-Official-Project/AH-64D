params ["_heli", "_collectiveMin", "_collectiveMax", "_cyclicPitchMin", "_cyclicPitchMax", "_cyclicRollMin", "_cyclicRollMax"];

private _input          = [_heli] call bmk_helisim_fnc_utilityGetInput;
private _collectiveVal  = _input # 0;
private _cyclicPitchVal = _input # 1;
private _cyclicRollVal  = _input # 2;

private _theta0_deg  = _collectiveMin + (_collectiveMax - _collectiveMin) * _collectiveVal;

private _AIC_deg     = linearConversion[-1.0, 1.0, _cyclicRollVal,  _cyclicRollMin, _cyclicRollMax];
private _BIC_deg     = linearConversion[-1.0, 1.0, _cyclicPitchVal, _cyclicPitchMin, _cyclicPitchMax];

[_theta0_deg, _AIC_deg, _BIC_deg];