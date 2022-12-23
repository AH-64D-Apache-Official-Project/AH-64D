params ["_heli", "_rotorParams", "_controlInputs"];

_rotorParams 
    params ["_a", "_type", "_b", "_h", "_R", "_c", "_theta1_deg", "_m", "_eR", "_e", "_gearRatio", "_thrustScalar", "_Ib", "_s", "_polarMOI", "_inputMaps"];
_controlInputs
     params ["_collectiveVal", "_cyclicPitchVal", "_cyclicRollVal", "_pedalVal", "_engineThrottleVal"];

private _theta0_deg = 0.0;
private _AIC_deg    = 0.0;
private _BIC_deg    = 0.0;

switch (_type) do {
    case 0: {   //Main rotor
        _inputMaps
            params ["_cyclicPitchMap_deg", "_cyclicRollMap_deg", "_collectivePitch_deg"];

        //Cyclic
        _AIC_deg    = ([_cyclicRollMap_deg,  _cyclicRollVal]  call fza_fnc_linearInterp) # 1;
        _BIC_deg    = ([_cyclicPitchMap_deg, _cyclicPitchVal] call fza_fnc_linearInterp) # 1;

        _collectivePitch_deg params ["_collectivePitchMin_deg", "_collectivePitchMax_deg"];
        _theta0_deg = _collectivePitchMin_deg + (_collectivePitchMax_deg - _collectivePitchMin_deg) * _collectiveVal;

        systemChat format ["Main Rotor AIC_Deg: %1 -- BIC_deg %2 -- theta0_deg %3", _AIC_deg toFixed 2, _BIC_deg toFixed 2, _theta0_deg toFixed 2];
    };
    case 1: {   //Tail rotor
        _inputMaps
            params ["_pedalPitchMap_deg"];
            
        _theta0_deg = ([_pedalPitchMap_deg,  _pedalVal]  call fza_fnc_linearInterp) # 1;

        systemChat format ["Tail Rotor theta0_deg %1", _theta0_deg toFixed 2];
    };
    case 2: {   //Propellor
        //Nothing yet...
    };
};

[_theta0_deg, _AIC_deg, _BIC_deg];