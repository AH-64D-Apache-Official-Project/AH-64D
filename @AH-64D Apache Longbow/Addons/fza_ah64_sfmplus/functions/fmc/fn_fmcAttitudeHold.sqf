params ["_heli", "_deltaTime"];

private _pidPitch = _heli getVariable "fza_sfmplus_pid_pitch";

//_pidPitch set ["kp", P_KP];
//_pidPitch set ["ki", P_KI];
//_pidPitch set ["kd", P_KD];

private _pidRoll  = _heli getVariable "fza_sfmplus_pid_roll";

//_pidRoll set ["kp", R_KP];
//_pidRoll set ["ki", R_KI];
//_pidRoll set ["kd", R_KD];

//
private _subMode    = _heli getVariable "fza_ah64_attHoldSubMode";
private _curVelX    = velocityModelSpace _heli # 0;
private _curVelY    = velocityModelSpace _heli # 1;

//Position hold...doesn't work
private _desiredPos = _heli getVariable "fza_ah64_attHoldDesiredPos";
private _curPos     = getPos _heli;
private _dist       = _heli distance2D _desiredPos;
private _dir        = _heli getRelDir [_desiredPos # 0, _desiredPos # 1];
private _distX      = _dist * (sin _dir);
private _distY      = _dist * (cos _dir);

//systemChat format ["Dist = %4 -- DistX = %1 -- DistY = %2 -- Dir = %3", _distX toFixed 2, _distY toFixed 2, _dir toFixed 2, _dist toFixed 2];
[_heli, 24, _desiredPos, 2.0, 2, "red", 1] call fza_fnc_debugDrawCircle;
systemChat format ["Desired Pos = %1", _desiredPos];

private _attHoldCycPitchOut = 0.0;
private _attHoldCycRollOut  = 0.0;

if ( _heli getVariable "fza_ah64_attHoldActive") then {
    //Position hold
    if (_subMode == "pos") then {
        _attHoldCycPitchOut = [_pidPitch, _deltaTime, 0.000, _curVelY] call fza_fnc_pidRun;
        _attHoldCycRollOut  = [_pidRoll,  _deltaTime, 0.000, _curVelX] call fza_fnc_pidRun;
    };
    //Velocity hold

    //Attitude hold
} else {
    [_pidPitch] call fza_fnc_pidReset;
    [_pidRoll]  call fza_fnc_pidReset;
};

[_attHoldCycPitchOut, _attHoldCycRollOut]