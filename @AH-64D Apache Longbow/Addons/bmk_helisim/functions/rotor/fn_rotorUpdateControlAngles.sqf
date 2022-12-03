params ["_heli", "_controlInputs", "_cyclicPitchMap_deg", "_cyclicRollMap_deg", "_collectivePitch_deg", "_pedalPitch_deg"];

_controlInputs
     params ["_collectiveVal", "_cyclicPitchVal", "_cyclicRollVal", "_pedalVal", "_engineThrottleVal"];

private _theta0_deg = 0.0;
private _AIC_deg    = 0.0;
private _BIC_deg    = 0.0;

if (!isnil "_collectivePitch_deg") then {
    //Main rotor
    _collectivePitch_deg params ["_collectivePitchMin_deg", "_collectivePitchMax_deg"];
    _theta0_deg = _collectivePitchMin_deg + (_collectivePitchMax_deg - _collectivePitchMin_deg) * _collectiveVal;
} else {
    //Tail rotor
    _theta0_deg = ([_pedalPitch_deg,  _pedalVal]  call fza_fnc_linearInterp) # 1;
    systemChat format ["theta0_deg: %1", _theta0_deg];
};

if (!isnil "_cyclicPitchMap_deg" && !isnil "_cyclicRollMap_deg") then {
    //Cyclic
    _AIC_deg    = ([_cyclicRollMap_deg,  _cyclicRollVal]  call fza_fnc_linearInterp) # 1;
    _BIC_deg    = ([_cyclicPitchMap_deg, _cyclicPitchVal] call fza_fnc_linearInterp) # 1;
};

[_theta0_deg, _AIC_deg, _BIC_deg];