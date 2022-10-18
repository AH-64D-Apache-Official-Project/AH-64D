params ["_heli", "_controlInputs", "_cyclicPitch_deg", "_cyclicRoll_deg",  "_collectivePitch_deg"];

_controlInputs       params ["_collectiveVal", "_cyclicPitchVal", "_cyclicRollVal"];
_cyclicPitch_deg     params ["_cyclicPitchMin_deg", "_cyclicPitchMax_deg"];
_cyclicRoll_deg      params ["_cyclicRollMin_deg",  "_cyclicRollMax_deg"];
_collectivePitch_deg params ["_collectivePitchMin_deg", "_collectivePitchMax_deg"];

private _theta0_deg = _collectivePitchMin_deg + (_collectivePitchMax_deg - _collectivePitchMin_deg) * _collectiveVal;

private _AIC_deg    = linearConversion[-1.0, 1.0, _cyclicRollVal,  _cyclicRollMin_deg,  _cyclicRollMax_deg];
private _BIC_deg    = linearConversion[-1.0, 1.0, _cyclicPitchVal, _cyclicPitchMin_deg, _cyclicPitchMax_deg];

[_theta0_deg, _AIC_deg, -_BIC_deg];