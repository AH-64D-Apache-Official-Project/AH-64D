params ["_heli", "_engNum", "_deltaTime", "_engInput", "_maxTorqueScalar", "_controlInputs"];

//systemChat format ["Eng %1 state is STARTING", _engNum];

private _engStart            = _heli getVariable "bmk_helisim_engStart" select _engNum;
private _engThrottlePos      = _heli getVariable "bmk_helisim_engThrottlePos" select _engNum;
private _engState            = _heli getVariable "bmk_helisim_engState" select _engNum;
private _engThrottleSetPoint = _heli getVariable "bmk_helisim_engThrottleSetPoint" select _engNum;

//This needs to check that Ng > min value and then transition to on...this is temporary
_engStart = false;
_engState = "ON";

if (_engThrottlePos == "OFF") then {
    _engStart = false;
    _engState = "OFF";
    _engThrottleSetPoint = 0.0;
};

[_heli, "bmk_helisim_engStart",            _engNum, _engStart] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engState",            _engNum, _engState] call fza_sfmplus_fnc_setArrayVariable;
[_heli, "bmk_helisim_engThrottleSetPoint", _engNum, _engThrottleSetPoint] call fza_sfmplus_fnc_setArrayVariable;