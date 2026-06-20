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

// ── Outputs ───────────────────────────────────────────────────────────────────
private _tqOutput = 0.0;
private _engFF    = _heli getVariable "fza_sfmplus_engFF" select _engNum;

if (_engState in ["STARTING", "ON"]) then {

    if (_engPowerLeverState == "FLY") then {

        if (_engOverspeed) then {
            _engPctNP = [_engPctNP, 1.22, 1.5 * _deltaTime] call BIS_fnc_lerp;
            _tqOutput = 0.0;
            _engPctTQ = _tqOutput / _engRefTq;

            if (_engPctNP >= 1.196) then {
                [_heli, "fza_sfmplus_engState",     _engNum, "OFF", true] call fza_fnc_setArrayVariable;
                [_heli, "fza_ah64_engineOverspeed", _engNum, false, true] call fza_fnc_setArrayVariable;
            };
        } else {
            // ── Available shaft power from Ng ─────────────────────────────────
            private _ngPowerFraction = [_engPctNG / _ngFlyRef, 0.0, 1.0] call BIS_fnc_clamp;
            private _availablePowerW = _continuousPower * 1000 * _ngPowerFraction;
            private _omegaGov        = _npFlyRef * _designRpm * 0.10472;
            private _availTq         = _availablePowerW / _omegaGov;

            // ── Load feed-forward — this engine's share of rotor demand ───────
            // The engine's steady-state torque target is the rotor's actual power
            // demand referred to the engine shaft (already gently smoothed in
            // fn_rotor). This is the baseline the governor trims around so NR
            // holds reference with no standing offset.
            private _rotorTqReq = 0.0;
            { _rotorTqReq = _rotorTqReq + _x; } forEach (_heli getVariable "fza_sfmplus_reqEngTorque");
            private _numActive  = if (_isSingleEng) then { 1 } else { 2 };
            private _myShareTq  = _rotorTqReq / _numActive;

            // ── Isochronous governor trim ─────────────────────────────────────
            // Proportional trim on normalised Np error. The feed-forward carries
            // the bulk of the load; this corrects the residual error that the
            // spool lag leaves behind.
            private _npFrac  = _xmsnRpm / (_npFlyRef * _designRpm);  // 1.0 = on-speed
            private _npErr   = 1.0 - _npFrac;                         // positive = underspeed
            private _govGain = 6.0;
            private _govCorr = [_npErr * _govGain, -0.5, 0.5] call BIS_fnc_clamp;

            // ── Engine spool dynamics ─────────────────────────────────────────
            // A real turboshaft cannot deliver new power instantly — Ng must
            // spool. We model that by lagging the ENTIRE torque demand (load
            // feed-forward + governor trim) through a first-order spool filter.
            //
            // This lag is what produces realistic NR behaviour: when cyclic tilts
            // the disc and rotor demand spikes, the engine lags behind for ~0.5 s,
            // so NR droops a percent or so, the governor adds trim, and NR
            // recovers. It also tames the torque response — the raw BET demand
            // spike from a cyclic input is filtered instead of hitting the
            // transmission at full magnitude.
            private _tqTarget = _myShareTq + (_availTq * _govCorr);
            _tqTarget = [_tqTarget, 0.0, _engRefTq * _engLimitTQ] call BIS_fnc_clamp;

            private _tqPrev  = _heli getVariable "fza_sfmplus_engOutputTq" select _engNum;
            private _tqAlpha = 1.0 - exp (-_deltaTime / 0.5);
            _tqOutput = _tqPrev + (_tqTarget - _tqPrev) * _tqAlpha;
            _tqOutput = [_tqOutput, 0.0, _engRefTq * _engLimitTQ] call BIS_fnc_clamp;

            // ── Fuel flow schedule (display) ──────────────────────────────────
            private _wfDemand = if (_availTq > 0.0) then { [_tqOutput / _availTq, 0.0, 1.0] call BIS_fnc_clamp } else { 0.0 };
            _engFF = [getArray (_sfmPlusConfig >> "engFFTable"), _wfDemand] call fza_fnc_linearInterp select 1;

            _engPctNP = _xmsnRpm / _designRpm;
            _engPctTQ = _tqOutput / _engRefTq;
        };

    } else {
        // IDLE: engine runs at idle Ng/Np, minimal torque output
        private _engIdleTQ = getNumber (_sfmPlusConfig >> "engIdleTQ");
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
