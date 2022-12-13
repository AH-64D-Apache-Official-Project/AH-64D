params ["_heli", "_rotorParams", "_engine", "_inputTorque"];

_rotorParams params ["_a", "_b", "_R", "_c", "_theta1", "_m", "_eR", "_e", "_gearRatio", "_Ib", "_s", "_polarMOI"];

private _numEng       = count _engine;
private _deltaRPM     = 0.0;
private _engInputTq   = 0.0;
private _outputRPM    = _heli getVariable "bmk_helisim_xmsnOutputRPM";

if (_numEng < 1 || _numEng > 2) exitWith { systemChat format ["Invalid engine configuration!"];  };

//Single engine transmission
if (_numEng == 1) then {
    _engine select 0 params ["_eng1OutputTq"];

    _engInputTq = _eng1OutputTq;

    _deltaRPM   = (_engInputTq - _inputTorque) / (_polarMOI / (_gearRatio * _gearRatio));
    _outputRPM  = _outputRPM + _deltaRPM;
};

if (_numEng == 2) then {
    _engine select 0 params ["_eng1OutputTq"];
    _engine select 1 params ["_eng2OutputTq"];

    _engInputTq = _eng1OutputTq + _eng2OutputTq;

    _deltaRPM   = (_engInputTq - _inputTorque) / (_polarMOI / (_gearRatio * _gearRatio));
    _outputRPM  = _outputRPM + _deltaRPM;
};

systemChat format ["Xmsn Output RPM: %1", _outputRPM];

_heli setVariable ["bmk_helisim_xmsnOutputRPM", _outputRPM];