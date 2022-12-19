params ["_heli", "_rtrNum", "_rho", "_rotorParams"];

_rotorParams 
    params ["_a", "_type", "_b", "_h", "_R", "_c", "_theta1_deg", "_m", "_eR", "_e", "_gearRatio", "_Ib", "_s", "_polarMOI", "_inputMaps"];


//21109 needs to pull from the current transmission RPM
//private _sfmPlusEng1_NP = (_heli getVariable "fza_sfmplus_engPctNP") # 0;
//private _sfmPlusEng2_NP = (_heli getVariable "fza_sfmplus_engPctNP") # 1;

//private _RPM = ((_sfmPlusEng1_NP max _sfmPlusEng2_NP) * 21109) / _gearRatio;

private _RPM    = (_heli getVariable "bmk_helisim_xmsnOutputRPM") / _gearRatio;
private _omega  = ((2.0 * pi) * _RPM) / 60.0;
private _omegaR = _omega * _R;
private _gamma  = (_rho * _a * _c * (_R * _R * _R * _R)) / _Ib;

systemChat format ["Rotor %1 RPM %2", _rtrNum, _RPM];

[_heli, "bmk_helisim_rotorRPM", _rtrNum, _RPM] call fza_sfmplus_fnc_setArrayVariable;

[_omega, _omegaR, _gamma];