#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli", "_engNum"];

private _continuosPower     = 1066.0;    //kW
private _contingencyPower   = 1447.0;    //kW
private _designRpm          = 20900;
private _engFriction        = 0.000000;

private _npIdleRef          = 0.57;
private _npFlyRef           = 1.01;

private _deltaTime          = _heli getVariable "fza_sfmplus_deltaTime";
private _rho                = _heli getVariable "fza_sfmplus_RHO";
private _engState           = _heli getVariable "fza_sfmplus_engState" select _engNum;
private _engPowerLeverState = _heli getVariable "fza_sfmplus_engPowerLeverState" select _engNum;
private _xmsnRpm            = _heli getVariable "fza_sfmplus_xmsnOutputRpm";
private _collectiveOutput   = _heli getVariable "fza_sfmplus_collectiveOutput";
private _engPid             = _heli getVariable "fza_sfmplus_pid_engine" select _engNum;
//_engPid set ["kp", E_KP];
//_engPid set ["ki", E_KI];
//_engPid set ["kd", E_KD];

private _npTrimRef          = 0.0;
private _throttle           = 0.0;
if (_engPowerLeverState == "IDLE") then {
    _throttle  = 0.09;
    _npTrimRef = _npIdleRef;
};
if (_engPowerLeverState == "FLY") then {
    _throttle  = 0.18;
    _npTrimRef = _npFlyRef;
};
_npTrimRef     = _npTrimRef * _designRpm;

private _engLimitTQ  = 0.0;
private _isSingleEng = _heli getVariable "fza_sfmplus_isSingleEng";
private _maxTQ_DE    = _heli getVariable "fza_sfmplus_maxTQ_DE";
private _maxTQ_SE    = _heli getVariable "fza_sfmplus_maxTQ_SE";

if (_isSingleEng) then {
    _engLimitTQ = _maxTQ_SE;
} else {
    _engLimitTQ = _maxTQ_DE;
};

private _engRefTq           = (_continuosPower * 1000) / 0.105 / _designRpm;
private _maxPowerInWatts    = (_continuosPower * 1000) * _engLimitTQ;
private _maxTorque          = _maxPowerInWatts / ((_designRpm * _npFlyRef) * 0.105);
private _trimTq             = 0.0;
private _tqOutput           = 0.0;
private _engPctNp           = 0.0;
private _engPctTq           = 0.0;

if (_engState in ["STARTING", "ON"]) then {
    if (_xmsnRpm > _npTrimRef || _xmsnRpm < _npTrimRef) then {
        _trimTq = [_engPid, _deltaTime, _npTrimRef, _xmsnRpm] call fza_fnc_pidRun;
        _trimTq = [_trimTq, _maxTorque * -0.5, _maxTorque * 0.5] call BIS_fnc_clamp;
    };
    _tqOutput = (_engRefTq * _throttle) + (_engRefTq * _collectiveOutput) + _trimTq;
    _tqOutput = [_tqOutput, 0.0, _maxTorque] call BIS_fnc_clamp;

    _engPctNp = _xmsnRpm / _designRpm;
    _engPctTq = _tqOutput / _engRefTq;
};
[_heli, "fza_sfmplus_engOutputTq", _engNum, _tqOutput, true] call fza_fnc_setArrayVariable;

[_heli, "fza_sfmplus_engPctNP",    _engNum, _engPctNp] call fza_fnc_setArrayVariable;
[_heli, "fza_sfmplus_engPctTQ",    _engNum, _engPctTq] call fza_fnc_setArrayVariable;


//systemChat format ["_engRefTq = %1 -- _maxPowerInWatts = %2 -- _maxOutputTq = %3", _engRefTq, _maxPowerInWatts, _maxTorque];
//systemChat format ["Engine %3 -- _trimTq = %1 -- _tqOutput = %2 -- _maxTorque = %4", _trimTq toFixed 2, _tqOutput toFixed 2, _engNum, _maxTorque];