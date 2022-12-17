params ["_heli", "_rtrNum", "_rho", "_rotorParams"];

_rotorParams 
    params ["_a", "_type", "_b", "_h", "_R", "_c", "_theta1_deg", "_m", "_eR", "_e", "_gearRatio", "_Ib", "_s", "_polarMOI", "_inputMaps"];

private _RPM    = _heli getVariable "bmk_helisim_rotorRPM" select _rtrNum;
private _omega  = ((2.0 * pi) * _RPM) / 60.0;
private _omegaR = _omega * _R;
private _gamma  = (_rho * _a * _c * (_R * _R * _R * _R)) / _Ib;

//21109 needs to pull from the current transmission RPM
private _sfmPlusEng1_NP = (_heli getVariable "fza_sfmplus_engPctNP") # 0;
private _sfmPlusEng2_NP = (_heli getVariable "fza_sfmplus_engPctNP") # 1;

_RPM = ((_sfmPlusEng1_NP max _sfmPlusEng2_NP) * 21109);

private _xmsnOutputRPM = _RPM;//_heli getVariable "bmk_helisim_xmsnOutputRPM";
private _currentRPM    = _xmsnOutputRPM / _gearRatio;

//systemChat format ["Rotor %1 RPM %2 -- Rtr RPM %3", _rtrNum, _RPM, _currentRPM];

[_heli, "bmk_helisim_rotorRPM", _rtrNum, _currentRPM] call fza_sfmplus_fnc_setArrayVariable;

[_omega, _omegaR, _gamma];