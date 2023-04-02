params ["_heli", "_engNum", "_deltaTime", "_engInput", "_maxTorqueScalar", "_controlInputs"];

_engInput
    params ["_refTq", "_gndIdleTq", "_fltIdleTq", "_flyTq", "_startNg", "_idleNg", "_flyNg", "_maxNg", "_gndIdleNp", "_fltIdleNp", "_flyNp"];

systemChat format ["Eng %1 state is STARTING", _engNum];

private _engStart            = _heli getVariable "bmk_helisim_engStart" select _engNum;
private _engThrottlePos      = _heli getVariable "bmk_helisim_engThrottlePos" select _engNum;
private _engState            = _heli getVariable "bmk_helisim_engState" select _engNum;
private _engThrottleSetPoint = _heli getVariable "bmk_helisim_engThrottleSetPoint" select _engNum;
private _engOutputNg         = _heli getVariable "bmk_helisim_engOutputNg" select _engNum;
private _engOutputRPM        = _heli getVariable "bmk_helisim_engOutputRPM" select _engNum;

if (_engStart == true && _engThrottlePos == "OFF") then {
    _engStart = false;
    _engState = "OFF";
    _engThrottleSetPoint = 0.0;
};

if (_engOutputNg >= 0.52) then {
    _engStart = false;
    _engState = "ON";
};

_engOutputNg  = [_engOutputNg,  _idleNg    + ((_flyNg - _idleNg)    * _engThrottleSetPoint), (1 / 5) * _deltaTime] call BIS_fnc_lerp;
_engOutputRPM = [_engOutputRPM, _gndIdleNP + ((_flyNp - _gndIdleNP) * _engThrottleSetPoint), (1 / 20) * _deltaTime] call BIS_fnc_lerp;    

[_heli, "bmk_helisim_engStart",            _engNum, _engStart] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engState",            _engNum, _engState] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engThrottleSetPoint", _engNum, _engThrottleSetPoint] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engOutputNg",         _engNum, _engOutputNg] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engOutputRPM",        _engNum, _engOutputRPM] call fza_sfmplus_fnc_setArrayVariable;