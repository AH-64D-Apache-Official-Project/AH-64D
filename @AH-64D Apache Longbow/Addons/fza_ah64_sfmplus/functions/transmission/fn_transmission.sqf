params ["_heli"];

private _mainRotorGearRatio = 72.29;
private _mainRotorMoi       = _heli getVariable "fza_sfmplus_rtrMoi" select 0;
private _outputRpm          = _heli getVariable "fza_sfmplus_xmsnOutputRpm";
private _deltaRpm           = _heli getVariable "fza_sfmplus_xmsnDeltaRpm";

private _totTq   = 0.0;
private _rotorTq = _heli getVariable "fza_sfmplus_reqEngTorque";
{
    _totTq = _totTq + _x;
} forEach _rotorTq;

private _engOutputTq = _heli getVariable "fza_sfmplus_engOutputTq";
private _engInputTq  = 0.0;
{
    _engInputTq = _engInputTq + _x;
} forEach _engOutputTq;

_deltaRpm  = if (_mainRotorMoi == 0.0) then { 0.0; } else { (_engInputTq - _totTq) / (_mainRotorMoi / (_mainRotorGearRatio * _mainRotorGearRatio)); };

if (_outputRpm < 0.0) then {
    _outputRpm = 0.0;
} else {
    _outputRpm = _outputRpm + _deltaRpm;
};

_heli setVariable ["fza_sfmplus_xmsnOutputRpm", _outputRpm];
_heli setVariable ["fza_sfmplus_xmsnDeltaRpm",  _deltaRpm];

//systemChat format ["_totTq = %1 -- _engInputTq = %2 -- _deltaRpm = %3", _totTq, _engInputTq, _deltaRpm];
//systemChat format ["_outputRpm = %1 -- _deltaRpm = %2", _outputRpm, _deltaRpm];