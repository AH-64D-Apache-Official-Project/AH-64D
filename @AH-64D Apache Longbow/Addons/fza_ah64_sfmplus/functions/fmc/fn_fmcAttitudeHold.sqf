params ["_heli", "_deltaTime"];

private _pidPitch = _heli getVariable "fza_sfmplus_pid_pitch";

//_pidPitch set ["kp", P_KP];
//_pidPitch set ["ki", P_KI];
//_pidPitch set ["kd", P_KD];

private _pidRoll  = _heli getVariable "fza_sfmplus_pid_roll";

//_pidRoll set ["kp", R_KP];
//_pidRoll set ["ki", R_KI];
//_pidRoll set ["kd", R_KD];

private _subMode  = _heli getVariable "fza_ah64_attHoldSubMode";
private _curVelX  = velocity _heli # 0;
private _curVelY  = velocity _heli # 1;

private _attHoldCycPitchOut = 0.0;
private _attHoldCycRollOut  = 0.0;

if ( _heli getVariable "fza_ah64_attHoldActive") then {
    //Position hold
    if (_subMode == "pos") then {
        _attHoldCycPitchOut = [_pidPitch, _deltaTime, 0.0, _curVelY] call fza_fnc_pidRun;
        _attHoldCycRollOut  = [_pidRoll,  _deltaTime, 0.0, _curVelX] call fza_fnc_pidRun;
    };
    //Velocity hold

    //Attitude hold
} else {
    [_pidPitch] call fza_fnc_pidReset;
    [_pidRoll]  call fza_fnc_pidReset;
};

[_attHoldCycPitchOut, _attHoldCycRollOut]