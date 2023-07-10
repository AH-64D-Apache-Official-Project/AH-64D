params ["_heli", "_deltaTime"];

#define FEET_TO_METERS 0.3048

private _mode      = _heli getVariable "fza_prestonai_heliMode";
private _curAltAGL = ASLToAGL getPosASL _heli # 2;
private _setAltAGL = _heli getVariable "fza_prestonai_setAltAGL";
//private _collOut   = _heli getVariable "fza_prestonai_collOutput";

private _hvr_pid_coll = _heli getVariable "fza_prestonai_pid_hvr_coll";
_hvr_pid_coll set ["kp", KP];
_hvr_pid_coll set ["ki", KI];
_hvr_pid_coll set ["kd", KD];
private _output       = 0.0;

if (_mode == "HVR") then {
    //Turn attitude hold on, and ensure 
    _heli setVariable ["fza_ah64_attHoldActive",  true];
    _heli setVariable ["fza_ah64_attHoldSubMode", "pos"];

    //Radar altitude hold uses AGL altitude
    private _altError = _curAltAGL - (_setAltAGL * FEET_TO_METERS);
    _output           = [_hvr_pid_coll, _deltaTime, 0.0, _altError] call fza_fnc_pidRun;
    //_collOut          = [_collOut, _output, 1.5, 0.75] call fza_fnc_expSeek;

    _heli setVariable ["fza_prestonai_collOutput", _output];
} else {
    [_hvr_pid_coll] call fza_fnc_pidReset;
};