params ["_heli", "_engNum", "_deltaTime", "_engInput", "_maxTorqueScalar", "_controlInputs"];

_engInput
    params ["_refTq", "_gndIdleTq", "_fltIdleTq", "_flyTq", "_gndIdleRPM", "_fltIdleRPM", "_flyRPM"];
_controlInputs
    params ["_collectiveVal", "_cyclicPitchVal", "_cyclicRollVal", "_pedalVal", "_engineThrottleVal"];

//systemChat format ["Eng %1 state is ON", _engNum];

private _engThrottlePos      = _heli getVariable "bmk_helisim_engThrottlePos" select _engNum;
private _engState            = _heli getVariable "bmk_helisim_engState" select _engNum;
private _engThrottleSetPoint = _heli getVariable "bmk_helisim_engThrottleSetPoint" select _engNum;
private _engOutputTq         = _heli getVariable "bmk_helisim_engOutputTq" select _engNum;
private _xmsnOutputRPM       = _heli getVariable "bmk_helisim_xmsnOutputRPM";

if (_engThrottlePos == "FLY") then {
    _engThrottleSetPoint = 1.0;
};

if (_engThrottlePos == "IDLE") then {
    _engThrottleSetPoint = 0.0;
};

if (_engThrottlePos == "OFF") then {
    _engState            = "OFF";
    _engThrottleSetPoint = 0.0;
};

private _baseTq = 0.0;
private _setTq  = 0.0;
private _setRPM = 0.0;
private _maxTq  = _refTq * _maxTorqueScalar;

_baseTq = _gndIdleTq  + (_flyTq - _gndIdleTq) * _engThrottleSetPoint;
_setTq  = _baseTq     + (_maxTQ - _baseTq)    * _engThrottleSetPoint * _collectiveVal;
_setRPM = _gndIdleRPM + (_flyRPM - _gndIdleRPM) * _engThrottleSetPoint;

([_heli, _setRPM, _xmsnOutputRPM, 0.35, 1.00, _collectiveVal] call bmk_helisim_fnc_utilityGovernor)
    params ["_govInput"];
_govInput = [_govInput, -_refTq * 0.75, _refTq * 0.25] call BIS_fnc_clamp;

//SINGLE ENG STUFF GOES HERE
_engOutputTq  = [_engOutputTq, _setTq + _govInput, _deltaTime] call BIS_fnc_lerp;
//SINGLE ENG STUFF GOES HERE

//systemChat format ["Eng %1 Set Tq: %2 -- Gov Input: %3 -- OutputTq: %4", _engNum, _setTq toFixed 2, _govInput tofixed 2, _engOutputTq tofixed 2];

_engOutputTq  = [_engOutputTq, 0.0, _maxTq] call BIS_fnc_clamp;

/*
//Engine power turbine speed (Np)
_outputRPM = if (_xmsnInputTq == 0.0) then { 0.0; } else { (30.0 * (_continuousPower / 0.001)) / (_xmsnInputTq * pi); };
_outputRPM = [_outputRPM, _setRPM, _deltaTime] call BIS_fnc_lerp;
//_outputRPM = [_outputRPM, 0.0, _setRPM] call BIS_fnc_clamp;

//Engine output torque
([_heli, _setRPM, _xmsnOutputRPM, 0.35, 1.00, _collectiveVal] call bmk_helisim_fnc_utilityGovernor)
    params ["_govInput"];

_outputTq  = [_outputTq, _setTq + _govInput, _deltaTime] call BIS_fnc_lerp;
_outputTq  = [_outputTq, 0.0, _maxTq] call BIS_fnc_clamp;
*/

[_heli, "bmk_helisim_engThrottleSetPoint", _engNum, _engThrottleSetPoint] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engState",            _engNum, _engState] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engOutputRPM",        _engNum, _setRPM] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engOutputTq",         _engNum, _engOutputTq] call fza_sfmplus_fnc_setArrayVariable;