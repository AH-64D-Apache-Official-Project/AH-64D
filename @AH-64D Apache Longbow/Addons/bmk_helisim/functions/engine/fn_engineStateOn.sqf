params ["_heli", "_engNum", "_deltaTime", "_engState", "_engThrottlePos", "_outputRPM", "_outputTq", "_xmsnInputTq", "_continuousPower", "_setRPM", "_setTq", "_maxTq"];

systemChat format ["Eng %1 state is ON", _engNum];

if (_engThrottlePos == "OFF") then {
    _engState = "OFF";
};

//Engine power turbine speed (Np)
_outputRPM = if (_xmsnInputTq == 0.0) then { 0.0; } else { (30.0 * (_continuousPower / 0.001)) / (_xmsnInputTq * pi); };
_outputRPM = [_outputRPM, _setRPM, _deltaTime] call BIS_fnc_lerp;

//Engine output torque
_outputTq  = [_outputTq, _setTq, _deltaTime] call BIS_fnc_lerp;
_outputTq  = [_outputTq, 0.0, _maxTq] call BIS_fnc_clamp;

[_heli, "bmk_helisim_engState",        _engNum, _engState] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engineOutputRPM", _engNum, _outputRPM] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engineOutputTq",  _engNum, _outputTq] call fza_sfmplus_fnc_setArrayVariable;