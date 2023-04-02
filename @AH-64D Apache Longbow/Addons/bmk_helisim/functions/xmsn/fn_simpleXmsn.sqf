params ["_heli", "_engine"];

private _numEng         = count _engine;
private _rtr0_torque    = _heli getVariable "bmk_helisim_rtrOutputTq" select 0;
private _rtr0_MOI       = _heli getVariable "bmk_helisim_rotor_polarMOI" select 0;
private _rtr0_gearRatio = _heli getVariable "bmk_helisim_rotor_gearRatio" select 0;
private _outputRPM      = _heli getVariable "bmk_helisim_xmsnOutputRPM";
//Engine 1
private _eng1ThrottlePos = _heli getVariable "bmk_helisim_engThrottlePos" select 0;
private _eng1OutputRPM   = _heli getVariable "bmk_helisim_engOutputRPM" select 0;
private _eng1OutputTq    = _heli getVariable "bmk_helisim_engOutputTq" select 0;
//Engine 2
private _eng2ThrottlePos = _heli getVariable "bmk_helisim_engThrottlePos" select 1;
private _eng2OutputRPM   = _heli getVariable "bmk_helisim_engOutputRPM" select 1;
private _eng2OutputTq    = _heli getVariable "bmk_helisim_engOutputTq" select 1;
//Torque
private _xmsnInputTq    = _rtr0_torque / _rtr0_gearRatio;

hintSilent format ["Xmsn Tq = %1", _xmsnInputTq];

if (_numEng < 1 || _numEng > 2) exitWith { systemChat format ["Invalid engine configuration!"];  };

_outputRPM = _eng1OutputRPM max _eng2OutputRPM;

if (_eng1ThrottlePos == "FLY" && _eng2ThrottlePos == "FLY") then {
    _eng1OutputTq = _xmsnInputTq / 2.0;
    _eng2OutputTq = _xmsnInputTq / 2.0;
};

if (_eng1ThrottlePos == "FLY" && _eng2ThrottlePos in ["IDLE", "OFF"]) then {
    _eng1OutputTq = _xmsnInputTq;
    _eng2OutputTq = 0.0;
};

if (_eng1ThrottlePos in ["IDLE", "OFF"] && _eng2ThrottlePos == "FLY") then {
    _eng1OutputTq = 0.0;
    _eng2OutputTq = _xmsnInputTq;
};

_heli setVariable ["bmk_helisim_xmsnOutputRPM", _outputRPM];

[_heli, "bmk_helisim_engOutputTq", 0, _eng1OutputTq] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engOutputTq", 1, _eng2OutputTq] call fza_sfmplus_fnc_setArrayVariable;