params ["_heli", "_rho", "_isTailRotor", "_rotorParams"];

_rotorParams params ["_a", "_b", "_R", "_c", "_theta1", "_m", "_eR", "_e", "_gearRatio", "_Ib", "_s"];

private _RPM    = 0.0;
if (!_isTailRotor) then { 
    _RPM =  _heli getVariable "bmk_helisim_mainRotor_RPM";
} else {
    _RPM =  _heli getVariable "bmk_helisim_tailRotor_RPM";
};
private _omega  = ((2.0 * pi) * _RPM) / 60.0;
private _omegaR = _omega * _R;
private _gamma  = (_rho * _a * _c * (_R * _R * _R * _R)) / _Ib;

//21109 needs to pull from the current transmission RPM
//private _sfmPlusEng1_NP = (_heli getVariable "fza_sfmplus_engPctNP") # 0;
//private _sfmPlusEng2_NP = (_heli getVariable "fza_sfmplus_engPctNP") # 1;

//_RPM = ((_sfmPlusEng1_NP max _sfmPlusEng2_NP) * 21109) / _gearRatio;

private _xmsnOutputRPM = _heli getVariable "bmk_helisim_xmsnOutputRPM";
private _currentRPM    = _xmsnOutputRPM / _gearRatio;

if (!_isTailRotor) then { 
    _heli setVariable ["bmk_helisim_mainRotor_RPM", _currentRPM];
} else {
    _heli setVariable ["bmk_helisim_tailRotor_RPM", _currentRPM];
};

[_omega, _omegaR, _gamma];