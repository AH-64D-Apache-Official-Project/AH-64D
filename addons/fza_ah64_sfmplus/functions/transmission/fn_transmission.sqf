params ["_heli"];

if (currentPilot _heli != player || !local _heli) exitWith {};

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

if (fza_ah64_sfmPlusRotorModel == 1) then {
    // ── BET driveline dynamics ────────────────────────────────────────────────
    // Lumped at the engine shaft, dimensionally correct and framerate-independent:
    //   alpha = tau_net / J_eng           [rad/s^2]
    //   J_eng = J_rotor / GR^2            (rotor inertia referred to engine shaft)
    //   d(rpm) = alpha * dt * (60 / 2pi)  (rad/s -> rpm over the frame)
    private _deltaTime = _heli getVariable "fza_sfmplus_deltaTime";
    private _jEng      = _mainRotorMoi / (_mainRotorGearRatio * _mainRotorGearRatio);
    private _alpha     = if (_jEng == 0.0) then { 0.0 } else { (_engInputTq - _totTq) / _jEng };
    _deltaRpm          = _alpha * _deltaTime * (60.0 / (2.0 * pi));
} else {
    // ── Simple rotor model (original behaviour — do not change) ────────────────
    _deltaRpm = if (_mainRotorMoi == 0.0) then { 0.0; } else { (_engInputTq - _totTq) / (_mainRotorMoi / (_mainRotorGearRatio * _mainRotorGearRatio)); };
};

if (_outputRpm < 0.0) then {
    _outputRpm = 0.0;
} else {
    _outputRpm = _outputRpm + _deltaRpm;
};

//systemChat format ["_outputRpm = %1", _outputRpm];

_heli setVariable ["fza_sfmplus_xmsnOutputRpm", _outputRpm];
_heli setVariable ["fza_sfmplus_xmsnDeltaRpm",  _deltaRpm];

//systemChat format ["_totTq = %1 -- _engInputTq = %2 -- _deltaRpm = %3", _totTq, _engInputTq, _deltaRpm];
//systemChat format ["_outputRpm = %1 -- _deltaRpm = %2", _outputRpm, _deltaRpm];
