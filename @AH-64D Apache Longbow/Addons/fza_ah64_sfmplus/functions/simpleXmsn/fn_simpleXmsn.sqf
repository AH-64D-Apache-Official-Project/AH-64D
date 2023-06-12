params ["_heli", "_simpleEgine"];

private _numEng = count _simpleEgine;
if (_numEng > 2) exitWith { systemChat "Invalid engine configuration!"; };

private _mainRtrTq        = _heli getVariable "fza_sfmplus_mainRtrTorque";
private _mainRtrMOI       = _heli getVariable "fza_sfmplus_mainRtrMOI";
private _mainRtrGearRatio = _heli getVariable "fza_sfmplus_mainRtrGearRatio";
private _engInputTq       = 0.0;
private _deltaRPM         = _heli getVariable "fza_sfmplus_xmsnDeltaRPM";
private _outputRPM        = _heli getVariable "fza_sfmplus_xmsnOutputRPM";
private _outputRPM_pct    = 0.0;

if (_numEng == 1) then {
    _simpleEgine 
} else {
    (_simpleEgine)
        params ["_eng1OutputTQ", "_eng2OutputTQ"];
    
    _engInputTq    = _eng1OutputTQ + _eng2OutputTQ;

    _deltaRPM      = (_engInputTq - _mainRtrTq) / (_mainRtrMOI / _mainRtrGearRatio^2);
    _outputRPM     = _outputRPM + _deltaRPM;
    _outputRPM_pct = _outputRPM / 20900;

    hintsilent format ["Xmsn is running! 
                        \nEng 1 Input Tq = %1
                        \nEng 2 Input Tq = %2
                        \nEng Input Tq = %6
                        \n----------
                        \nMain Rtr Tq = %3
                        \nMain Rtr MOI = %4
                        \nMain Rtr Gear Ratio = %5
                        \n----------
                        \nOutput RPM = %7
                        \nOutput RPM PCT = %8", 
                        _eng1OutputTQ toFixed 2,
                        _eng2OutputTQ toFixed 2,
                        _mainRtrTq toFixed 2,
                        _mainRtrMOI toFixed 2,
                        _mainRtrGearRatio toFixed 2,
                        _engInputTq toFixed 2,
                        _outputRPM,
                        _outputRPM_pct toFixed 2];
};

_heli setVariable ["fza_sfmplus_xmsnDeltaRPM",      _deltaRPM];
_heli setVariable ["fza_sfmplus_xmsnOutputRPM",     _outputRPM];
_heli setVariable ["fza_sfmplus_xmsnOutputRPM_pct", _outputRPM_pct];