params ["_heli", "_engNum", "_deltaTime", "_engState", "_engStart", "_engThrottlePos", "_engThrottleSetPoint",  "_outputRPM", "_outputTq"];

//systemChat format ["Eng %1 state is OFF", _engNum];

if (_engStart == true) then {
    if (_engThrottlePos == "IDLE") then {
        _engState = "STARTING";
        _engThrottleSetPoint = 0.0;
    };
};

_outputRPM = [_outputRPM, 0.0, _deltaTime] call BIS_fnc_lerp;
_outputTq  = [_outputTq, 0.0, _deltaTime] call BIS_fnc_lerp;

[_heli, "bmk_helisim_engState",        _engNum, _engState] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engThrottlePos",  _engNum, _engThrottlePos] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engineOutputRPM", _engNum, _outputRPM] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engineOutputTq",  _engNum, _outputTq] call fza_sfmplus_fnc_setArrayVariable;