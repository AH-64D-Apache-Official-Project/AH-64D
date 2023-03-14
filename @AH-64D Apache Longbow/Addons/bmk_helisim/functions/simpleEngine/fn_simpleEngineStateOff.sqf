params ["_heli", "_engNum", "_deltaTime", "_engInput", "_maxTorqueScalar", "_controlInputs"];

_engInput
    params ["_refTq", "_gndIdleTq", "_fltIdleTq", "_flyTq", "_idleNg", "_flyNg", "_maxNg", "_gndIdleNp", "_fltIdleNp", "_flyNp"];

    private _engStart            = _heli getVariable "bmk_helisim_engStart" select _engNum;
    private _engThrottlePos      = _heli getVariable "bmk_helisim_engThrottlePos" select _engNum;
    private _engState            = _heli getVariable "bmk_helisim_engState" select _engNum;
    private _engThrottleSetPoint = _heli getVariable "bmk_helisim_engThrottleSetPoint" select _engNum;
    private _engOutputNg         = _heli getVariable "bmk_helisim_engOutputNg" select _engNum;
    
    if (_engStart == true) then {
        if (_engThrottlePos == "IDLE") then {
            _engState = "STARTING";
            _engThrottleSetPoint = 0.0;
        };
    };
    
    _engOutputNg  = [_engOutputNg, 0.0, _deltaTime] call BIS_fnc_lerp;
    
    [_heli, "bmk_helisim_engState",            _engNum, _engState] call fza_sfmplus_fnc_setArrayVariable;
    [_heli, "bmk_helisim_engThrottleSetPoint", _engNum, _engThrottleSetPoint] call fza_sfmplus_fnc_setArrayVariable;
    [_heli, "bmk_helisim_engOutputNg",         _engNum, _engOutputNg] call fza_sfmplus_fnc_setArrayVariable;