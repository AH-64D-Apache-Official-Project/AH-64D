params ["_heli", "_deltaTime"];

//Roll
private _pidRoll  = _heli getVariable "fza_sfmplus_pid_roll";
//Pitch
private _pidPitch = _heli getVariable "fza_sfmplus_pid_pitch";

//
private _subMode  = _heli getVariable "fza_ah64_attHoldSubMode";
private _curVel   = velocityModelSpace _heli;
private _curVelX  = (_curVel # 0) * -1.0;
private _curVelY  = _curVel # 1;

private _attHoldCycPitchOut = 0.0;
private _attHoldCycRollOut  = 0.0;

//If the attitude hold is enabled, and the force trim isn't interupted, then attitude hold is actually active
if ( _heli getVariable "fza_ah64_attHoldActive" && !(_heli getVariable "fza_ah64_forceTrimInterupted")) then {
    //Position hold
    if (_subMode == "pos") then {

        private _roll  = [_pidRoll,  _deltaTime, 0.0, _curVelX] call fza_fnc_pidRun;    //(_curVelX + _distX) / 2.0
        _roll          = [_roll,  -1.0, 1.0] call BIS_fnc_clamp;
        private _pitch = [_pidPitch, _deltaTime, 0.0, _curVelY] call fza_fnc_pidRun;    //(_curVelY - _distY) / 2.0
        _pitch         = [_pitch, -1.0, 1.0] call BIS_fnc_clamp;

        _attHoldCycPitchOut = _pitch;
        _attHoldCycRollOut  = _roll;
    };
    //Velocity hold
    if (_subMode == "vel") then {
        (_heli getVariable "fza_ah64_attHoldDesiredVel")
            params ["_setVelX", "_setVelY"];

        private _roll  = [_pidRoll,  _deltaTime, _setVelX, _curVelX] call fza_fnc_pidRun;
        _roll          = [_roll,  -1.0, 1.0] call BIS_fnc_clamp;
        private _pitch = [_pidPitch, _deltaTime, _setVelY, _curVelY] call fza_fnc_pidRun;
        _pitch         = [_pitch, -1.0, 1.0] call BIS_fnc_clamp;

        systemChat format ["Vel Hold! Des X %1 -- Des Y %2", _setVelX, _setVelY];

        _attHoldCycPitchOut = _pitch;
        _attHoldCycRollOut  = _roll;
    };
    //Attitude hold
} else {
    [_pidRoll]  call fza_fnc_pidReset;
    [_pidPitch] call fza_fnc_pidReset;
};

//systemChat format ["Dist = %4 -- DistX = %1 -- DistY = %2 -- Dir = %3", _distX toFixed 2, _distY toFixed 2, _dir toFixed 2, _dist toFixed 2];
//systemChat format ["VelX = %1 -- VelY = %2 -- Pitch Out = %3 -- Roll Out = %4", _curVelX toFixed 2, _curVelY toFixed 2, _attHoldCycPitchOut toFixed 2, _attHoldCycRollOut toFixed 2];

[_attHoldCycPitchOut, _attHoldCycRollOut]