params ["_heli", "_deltaTime"];

_heli setVariable ["fza_sfmplus_pid_altHold", [KP, KI, KD] call fza_fnc_pidCreate];


private _pid    = _heli getVariable "fza_sfmplus_pid_altHold";
systemChat format ["Alt Hold PID = %1", _pid];

private _output = [_pid, _deltaTime, 15.24, ASLToAGL getPosASL _heli # 2] call fza_fnc_pidRun;

_output;