params ["_heli", "_controlInputs", "_cyclicPitch", "_cyclicRoll",  "_collectivePitch"];

_controlInputs   params ["_collectiveVal", "_cyclicPitchVal", "_cyclicRollVal"];
_cyclicPitch     params ["_cyclicPitchMin", "_cyclicPitchMax"];
_cyclicRoll      params ["_cyclicRollMin", "_cyclicRollMax"];
_collectivePitch params ["_collectivePitchMin", "_collectivePitchMax"];

private _theta0_deg = _collectivePitchMin + (_collectivePitchMax - _collectivePitchMin) * _collectiveVal;
private _theta0     = rad _theta0_deg;

private _AIC_deg    = linearConversion[-1.0, 1.0, _cyclicRollVal,  _cyclicRollMin, _cyclicRollMax];
private _BIC_deg    = linearConversion[-1.0, 1.0, _cyclicPitchVal, _cyclicPitchMin, _cyclicPitchMax];

[_theta0, _AIC_deg, _BIC_deg];