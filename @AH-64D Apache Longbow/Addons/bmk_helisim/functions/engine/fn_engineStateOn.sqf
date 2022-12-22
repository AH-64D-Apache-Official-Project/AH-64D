params ["_heli", "_engNum", "_deltaTime", "_engState", "_engThrottlePos", "_outputRPM", "_collectiveVal", "_outputTq", "_continuousPower", "_setRPM", "_setTq", "_refTq", "_maxTq"];

//systemChat format ["Eng %1 state is ON", _engNum];

private _xmsnOutputRPM = _heli getVariable "bmk_helisim_xmsnOutputRPM";
private _xmsnInputTq   = _heli getVariable "bmk_helisim_rtrOutputTq" select 0;

if (_engThrottlePos == "OFF") then {
    _engState = "OFF";
};

//Engine power turbine speed (Np)
_outputRPM = if (_xmsnInputTq == 0.0) then { 0.0; } else { (30.0 * (_continuousPower / 0.001)) / (_xmsnInputTq * pi); };
_outputRPM = [_outputRPM, _setRPM, _deltaTime] call BIS_fnc_lerp;
//_outputRPM = [_outputRPM, 0.0, _setRPM] call BIS_fnc_clamp;

//Engine output torque
([_heli, _setRPM, _xmsnOutputRPM, 0.35, 1.00, _collectiveVal] call bmk_helisim_fnc_utilityGovernor)
    params ["_govInput"];

_outputTq  = [_outputTq, _setTq + _govInput, _deltaTime] call BIS_fnc_lerp;
_outputTq  = [_outputTq, 0.0, _maxTq] call BIS_fnc_clamp;

[_heli, "bmk_helisim_engState",     _engNum, _engState] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engOutputRPM", _engNum, _outputRPM] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engOutputTq",  _engNum, _outputTq] call fza_sfmplus_fnc_setArrayVariable;