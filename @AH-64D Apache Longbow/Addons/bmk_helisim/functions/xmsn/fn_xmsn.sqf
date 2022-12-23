params ["_heli", "_engine"];

private _numEng         = count _engine;
private _engInputTq    = 0.0;
private _rtr0_torque    = _heli getVariable "bmk_helisim_rtrOutputTq" select 0;
private _rtr0_MOI       = _heli getVariable "bmk_helisim_rotor_polarMOI" select 0;
private _rtr0_gearRatio = _heli getVariable "bmk_helisim_rotor_gearRatio" select 0;
private _deltaRPM       = 0.0;
private _outputRPM      = _heli getVariable "bmk_helisim_xmsnOutputRPM";
private _xmsnInputTq    = _rtr0_torque / _rtr0_gearRatio;

if (_numEng < 1 || _numEng > 2) exitWith { systemChat format ["Invalid engine configuration!"];  };

//Single engine transmission
if (_numEng == 1) then {
    _engInputTq = _heli getVariable "bmk_helisim_engOutputTq" select 0;

    _deltaRPM   = (_engInputTq - _xmsnInputTq) / (_rtr0_MOI / (_rtr0_gearRatio * _rtr0_gearRatio));
    _outputRPM  = _outputRPM + _deltaRPM;
};

if (_numEng == 2) then {
    private _eng1OutputTq = _heli getVariable "bmk_helisim_engOutputTq" select 0;
    private _eng2OutputTq = _heli getVariable "bmk_helisim_engOutputTq" select 1;
    _engInputTq = _eng1OutputTq + _eng2OutputTq;

    _deltaRPM   = (_engInputTq - _xmsnInputTq) / (_rtr0_MOI / (_rtr0_gearRatio * _rtr0_gearRatio));
    _outputRPM  = _outputRPM + _deltaRPM;
};
//systemChat format ["Eng Input Tq: %1  Xmsn Input Tq %2", _engInputTq, _xmsnInputTq];

_heli setVariable ["bmk_helisim_xmsnOutputRPM", _outputRPM];