params ["_heli", "_deltaTime"];

//Roll
private _pidRoll  = _heli getVariable "fza_sfmplus_pid_roll";
//Pitch
private _pidPitch = _heli getVariable "fza_sfmplus_pid_pitch";

//
private _subMode  = _heli getVariable "fza_ah64_attHoldSubMode";
private _curVelX  = (velocityModelSpace _heli # 0) * -1.0;
private _curVelY  = velocityModelSpace _heli # 1;

//Position hold...doesn't work
//private _desiredPos = _heli getVariable "fza_ah64_attHoldDesiredPos";
//private _curPos     = getPos _heli;
//private _dist       = _heli distance2D _desiredPos;
//private _dir        = _heli getRelDir [_desiredPos # 0, _desiredPos # 1];
//private _distX      = _dist * (sin _dir);
//private _distY      = _dist * (cos _dir);

private _attHoldCycPitchOut = 0.0;
private _attHoldCycRollOut  = 0.0;

//If the attitude hold is enabled, and the force trim isn't interupted, then attitude hold is actually active
if ( _heli getVariable "fza_ah64_attHoldActive" && !(_heli getVariable "fza_ah64_forceTrimInterupted")) then {
    //Position hold
    if (_subMode == "pos") then {

        private _roll  = [_pidRoll,  _deltaTime, 0.0, _curVelX] call fza_fnc_pidRun;    //(_curVelX + _distX) / 2.0
        _roll          = [_roll, -1.0, 1.0] call BIS_fnc_clamp;
        private _pitch = [_pidPitch, _deltaTime, 0.0, _curVelY] call fza_fnc_pidRun;    //(_curVelY - _distY) / 2.0
        _pitch         = [_pitch, -1.0, 1.0] call BIS_fnc_clamp;

        _attHoldCycPitchOut = _pitch;
        _attHoldCycRollOut  = _roll;
    };
    //Velocity hold

    //Attitude hold
} else {
    [_pidRoll]  call fza_fnc_pidReset;
    [_pidPitch] call fza_fnc_pidReset;
};

//systemChat format ["Dist = %4 -- DistX = %1 -- DistY = %2 -- Dir = %3", _distX toFixed 2, _distY toFixed 2, _dir toFixed 2, _dist toFixed 2];
//systemChat format ["VelX = %1 -- VelY = %2 -- Pitch Out = %3 -- Roll Out = %4", _curVelX toFixed 2, _curVelY toFixed 2, _attHoldCycPitchOut toFixed 2, _attHoldCycRollOut toFixed 2];

[_attHoldCycPitchOut, _attHoldCycRollOut]