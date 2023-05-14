params ["_heli", "_deltaTime"];

//Roll
private _pidVelX = _heli getVariable "fza_sfmplus_pid_velX";
private _pidPosX = _heli getVariable "fza_sfmplus_pid_posX";
//_pidRoll set ["kp", R_KP];
//_pidRoll set ["ki", R_KI];
//_pidRoll set ["kd", R_KD];

//Pitch
private _pidVelY = _heli getVariable "fza_sfmplus_pid_velY";
private _pidPosY = _heli getVariable "fza_sfmplus_pid_posY";
//_pidPitch set ["kp", P_KP];
//_pidPitch set ["ki", P_KI];
//_pidPitch set ["kd", P_KD];

//
private _subMode    = _heli getVariable "fza_ah64_attHoldSubMode";
private _curVelX    = (velocityModelSpace _heli # 0) * -1.0;
private _curVelY    = velocityModelSpace _heli # 1;

//Position hold...doesn't work
private _desiredPos = _heli getVariable "fza_ah64_attHoldDesiredPos";
private _curPos     = getPos _heli;
private _dist       = _heli distance2D _desiredPos;
private _dir        = _heli getDir [_desiredPos # 0, _desiredPos # 1];
private _distX      = _dist * (sin _dir);
private _distY      = _dist * (cos _dir);

private _attHoldCycPitchOut = 0.0;
private _attHoldCycRollOut  = 0.0;

if ( _heli getVariable "fza_ah64_attHoldActive") then {
    //Position hold
    if (_subMode == "pos") then {
        private _velX = [_pidVelX, _deltaTime, 0.0, _curVelX] call fza_fnc_pidRun;
        private _velY = [_pidVelY, _deltaTime, 0.0, _curVelY] call fza_fnc_pidRun;

        private _posX = [_pidPosX, _deltaTime, 0.0, _distX]   call fza_fnc_pidRun;
        private _posY = [_pidPosY, _deltaTime, 0.0, _distY]   call fza_fnc_pidRun;

        _attHoldCycPitchOut = _velY;//(_velY - _posY) / 2.0;
        _attHoldCycRollOut  = _velX;//(_velX + _posX) / 2.0;
    };
    //Velocity hold

    //Attitude hold
} else {
    [_pidPitch] call fza_fnc_pidReset;
    [_pidRoll]  call fza_fnc_pidReset;
};

//systemChat format ["Dist = %4 -- DistX = %1 -- DistY = %2 -- Dir = %3", _distX toFixed 2, _distY toFixed 2, _dir toFixed 2, _dist toFixed 2];
//systemChat format ["VelX = %1 -- VelY = %2 -- Pitch Out = %3 -- Roll Out = %4", _curVelX toFixed 2, _curVelY toFixed 2, _attHoldCycPitchOut toFixed 2, _attHoldCycRollOut toFixed 2];

[_attHoldCycPitchOut, _attHoldCycRollOut]