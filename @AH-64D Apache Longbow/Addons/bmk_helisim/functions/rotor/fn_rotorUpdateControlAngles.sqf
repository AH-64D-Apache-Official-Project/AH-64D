params ["_heli", "_controlInputs", "_cyclicPitchMap_deg", "_cyclicRollMap_deg",  "_collectivePitch_deg"];

_controlInputs       params ["_collectiveVal", "_cyclicPitchVal", "_cyclicRollVal"];
_collectivePitch_deg params ["_collectivePitchMin_deg", "_collectivePitchMax_deg"];

private _theta0_deg = _collectivePitchMin_deg + (_collectivePitchMax_deg - _collectivePitchMin_deg) * _collectiveVal;

private _AIC_deg    = ([_cyclicRollMap_deg,  _cyclicRollVal]  call fza_fnc_linearInterp) # 1;
private _BIC_deg    = ([_cyclicPitchMap_deg, _cyclicPitchVal] call fza_fnc_linearInterp) # 1;

[_theta0_deg, _AIC_deg, _BIC_deg];