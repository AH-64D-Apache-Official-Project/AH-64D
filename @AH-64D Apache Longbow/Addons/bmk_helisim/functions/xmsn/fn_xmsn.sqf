params ["_heli", "_engine"];

private _numEng        = count _engine;
private _deltaRPM      = 0.0;
private _engInputTq    = 0.0;
private _xmsnInputTq   = _heli getVariable "bmk_helisim_rotor_outputTorque" select 0;
private _rtr0MOI       = _heli getVariable "bmk_helisim_rotor_polarMOI" select 0;
private _rtr0gearRatio = _heli getVariable "bmk_helisim_rotor_gearRatio" select 0;
private _outputRPM     = _heli getVariable "bmk_helisim_xmsnOutputRPM";

if (_numEng < 1 || _numEng > 2) exitWith { systemChat format ["Invalid engine configuration!"];  };

//Single engine transmission
if (_numEng == 1) then {
    _engine select 0 params ["_eng1OutputTq"];

    _engInputTq  = _eng1OutputTq;

    _deltaRPM    = (_engInputTq - _xmsnInputTq) / (_rtr0MOI / (_rtr0gearRatio * _rtr0gearRatio));
    _outputRPM   = _outputRPM + _deltaRPM;
};

if (_numEng == 2) then {
    _engine select 0 params ["_eng1OutputTq"];
    _engine select 1 params ["_eng2OutputTq"];

    _engInputTq = _eng1OutputTq + _eng2OutputTq;

    _deltaRPM   = (_engInputTq - _xmsnInputTq) / (_rtr0MOI / (_rtr0gearRatio * _rtr0gearRatio));
    _outputRPM  = _outputRPM + _deltaRPM;
};
systemChat format ["Eng Input Tq: %1  Xmsn Input Tq %2", _engInputTq, _xmsnInputTq];

_outputRPM  = [_outputRPM, 0.0, 21109] call bis_fnc_clamp;

_heli setVariable ["bmk_helisim_xmsnOutputRPM", _outputRPM];