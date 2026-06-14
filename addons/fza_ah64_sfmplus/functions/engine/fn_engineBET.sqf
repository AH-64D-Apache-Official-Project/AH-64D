#include "\fza_ah64_sfmplus\headers\core.hpp"
#include "\fza_ah64_systems\headers\systems.hpp"

params ["_heli", "_engNum"];

private _cfg           = configOf _heli;
private _sfmPlusConfig = _cfg >> "Fza_SfmPlus";

// ── Physical constants ────────────────────────────────────────────────────────
private _continuousPower  = 1066.0;   // kW continuous per engine
private _designRpm        = 20900;    // 100% Np RPM
private _npFlyRef         = 1.01;     // governed Np target (fraction)
private _npIdleRef        = 0.57;     // idle Np target (fraction)
private _ngFlyRef         = 0.856;    // Ng at fly power (fraction)
private _ngIdleRef        = 0.674;    // Ng at idle (fraction)

// Reference torque at 100% Np: Q = P / omega
private _engRefTq = (_continuousPower * 1000) / (_designRpm * _npFlyRef * 0.10472);

// ── Frame state ───────────────────────────────────────────────────────────────
private _deltaTime          = _heli getVariable "fza_sfmplus_deltaTime";
private _engState           = _heli getVariable "fza_sfmplus_engState"          select _engNum;
private _engPowerLeverState = _heli getVariable "fza_sfmplus_engPowerLeverState" select _engNum;
private _engPctNG           = _heli getVariable "fza_sfmplus_engPctNG"          select _engNum;
private _engPctNP           = _heli getVariable "fza_sfmplus_engPctNP"          select _engNum;
private _engPctTQ           = _heli getVariable "fza_sfmplus_engPctTQ"          select _engNum;
private _engPid             = _heli getVariable "fza_sfmplus_pid_engine"        select _engNum;
private _engOverspeed       = _heli getVariable "fza_ah64_engineOverspeed"      select _engNum;
private _randomTq           = _heli getVariable "fza_sfmplus_randomTq";
private _isSingleEng        = _heli getVariable "fza_sfmplus_isSingleEng";
private _xmsnRpm            = _heli getVariable "fza_sfmplus_xmsnOutputRpm";
private _collectiveOutput   = _heli getVariable "fza_sfmplus_collectiveOutput";

// ── Torque limits ─────────────────────────────────────────────────────────────
private _maxTQ_DE   = _heli getVariable "fza_sfmplus_maxTQ_DE";
private _maxTQ_SE   = _heli getVariable "fza_sfmplus_maxTQ_SE";
private _engLimitTQ = if (_isSingleEng) then { _maxTQ_SE } else { _maxTQ_DE };

// ── Rotor load — this engine's share ─────────────────────────────────────────
private _totalRotorTqReq  = 0.0;
{ _totalRotorTqReq = _totalRotorTqReq + _x; } forEach (_heli getVariable "fza_sfmplus_reqEngTorque");
private _numActive  = if (_isSingleEng) then { 1 } else { 2 };
private _myShareTq  = _totalRotorTqReq / _numActive;

// ── Outputs ───────────────────────────────────────────────────────────────────
private _tqOutput = 0.0;
private _engFF    = _heli getVariable "fza_sfmplus_engFF" select _engNum;

if (_engState in ["STARTING", "ON"]) then {

    if (_engPowerLeverState == "FLY") then {

        if (_engOverspeed) then {
            _engPctNP = [_engPctNP, 1.22, 1.5 * _deltaTime] call BIS_fnc_lerp;
            _tqOutput = _myShareTq;
            _engPctTQ = _tqOutput / _engRefTq;

            if (_engPctNP >= 1.196) then {
                [_heli, "fza_sfmplus_engState",     _engNum, "OFF", true] call fza_fnc_setArrayVariable;
                [_heli, "fza_ah64_engineOverspeed", _engNum, false, true] call fza_fnc_setArrayVariable;
            };
        } else {
            // ── Fuel flow ─────────────────────────────────────────────────────
            // Base fuel flow from throttle (Ng target), trimmed by collective demand.
            // Collective increases fuel to meet power turbine load — this is the
            // FADEC droop governor response to rotor load increases.
            private _npTrimRef  = _npFlyRef * _designRpm;
            private _npError    = (_npTrimRef - _xmsnRpm) / _npTrimRef;  // positive = underspeed

            // Governor fuel trim: add fuel when Np droops, reduce when Np overspeeds
            private _govTrim = [_engPid, _deltaTime, _npTrimRef, _xmsnRpm] call fza_fnc_pidRun;
            _govTrim = [_govTrim, -0.3, 0.3] call BIS_fnc_clamp;

            // Fuel flow schedule: throttle base + collective demand + governor trim
            // Collective reflects actual power demand on the power turbine
            private _wfDemand = 0.18 + (_collectiveOutput * 0.64) + _govTrim;
            _wfDemand = [_wfDemand, 0.0, 1.0] call BIS_fnc_clamp;

            // Fuel flow in kg/s from table (used for display and Ng drive)
            _engFF = [getArray (_sfmPlusConfig >> "engFFTable"), _wfDemand] call fza_fnc_linearInterp select 1;

            // ── Available shaft power from Ng ─────────────────────────────────
            // Ng determines how much continuous power the gas generator supplies.
            // _engLimitTQ is a torque output cap multiplier, NOT a power multiplier —
            // do not apply it here or available power inflates to 134% of continuous.
            private _ngPowerFraction = [_engPctNG / _ngFlyRef, 0.0, 1.0] call BIS_fnc_clamp;
            private _availablePowerW = _continuousPower * 1000 * _ngPowerFraction;

            // ── Power turbine torque ──────────────────────────────────────────
            // Available torque at governed Np. Use governed omega so shaft power
            // is set by fuel/Ng; transmission integration handles RPM drift.
            private _omegaGov = _npFlyRef * _designRpm * 0.10472;
            private _availTq  = _availablePowerW / _omegaGov;

            // ── Governor output ───────────────────────────────────────────────
            // Engine follows rotor demand closely, but the isochronous governor
            // adds a small surplus proportional to Np underspeed (or withdraws
            // torque on overspeed). This lets NR droop ~1% under load and recover.
            // _govTrim is already computed above as a PID on Np error.
            // Map govTrim [-0.3, 0.3] to a torque delta [-15%, +15%] of _availTq.
            private _govDelta = _govTrim * _availTq * 0.5;

            // Output: demand share + governor correction, clamped to [0, limit]
            _tqOutput = _myShareTq + _govDelta;
            _tqOutput = [_tqOutput, 0.0, _engRefTq * _engLimitTQ] call BIS_fnc_clamp;

            _engPctNP = _xmsnRpm / _designRpm;
            _engPctTQ = _tqOutput / _engRefTq;
        };

    } else {
        // IDLE: engine runs at idle Ng/Np, minimal torque output
        private _npTrimRef = _npIdleRef * _designRpm;
        private _govTrim   = [_engPid, _deltaTime, _npTrimRef, _xmsnRpm] call fza_fnc_pidRun;
        _govTrim   = [_govTrim, 0.0, _engRefTq * 0.15] call BIS_fnc_clamp;
        _tqOutput  = _govTrim;
        _engFF     = [getArray (_sfmPlusConfig >> "engFFTable"), _engIdleTQ] call fza_fnc_linearInterp select 1;

        _engPctNP = _xmsnRpm / _designRpm;
        _engPctTQ = _tqOutput / _engRefTq;
    };

} else {
    _engPctNP = [_engPctNP, 0.0, _deltaTime] call BIS_fnc_lerp;
    _tqOutput = 0.0;
    _engPctTQ = 0.0;
    _engFF    = 0.0;
};

// ── Write outputs ─────────────────────────────────────────────────────────────
[_heli, "fza_sfmplus_engOutputTq", _engNum, _tqOutput,  true] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engPctNP",    _engNum, _engPctNP       ] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engFF",       _engNum, _engFF          ] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engPctTQ",    _engNum, _engPctTQ + (_randomTq select _engNum) + (_randomTq select (_engNum + 2))] call fza_fnc_setArrayVariable;
