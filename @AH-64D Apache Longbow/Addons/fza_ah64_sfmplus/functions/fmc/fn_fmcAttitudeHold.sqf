params ["_heli"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

//Roll
private _pidRoll      = _heli getVariable "fza_sfmplus_pid_roll";
//_pidRoll set ["kp", R_KP];
//_pidRoll set ["ki", R_KI];
//_pidRoll set ["kd", R_KD];
private _pidRoll_att  = _heli getVariable "fza_sfmplus_pid_roll_att";
//_pidRoll_att set ["kp", R_KP];
//_pidRoll_att set ["ki", R_KI];
//_pidRoll_att set ["kd", R_KD];

//Pitch
private _pidPitch     = _heli getVariable "fza_sfmplus_pid_pitch";
//_pidPitch set ["kp", P_KP];
//_pidPitch set ["ki", P_KI];
//_pidPitch set ["kd", P_KD];
private _pidPitch_att = _heli getVariable "fza_sfmplus_pid_pitch_att";
//_pidPitch_att set ["kp", R_KP];
//_pidPitch_att set ["ki", R_KI];
//_pidPitch_att set ["kd", R_KD];

//Position & Velocity hold
private _subMode  = _heli getVariable "fza_ah64_attHoldSubMode";

((_heli getVariable "fza_sfmplus_velModelSpace"))
    params [
             "_velX"
           , "_velY"
           , "_velZ"
           ];

((_heli getVariable "fza_sfmplus_angVelModelSpace"))
    params [
             "_angVelX"
           , "_angVelY"
           , "_angVelZ"
           ];

private _deltaTime = _heli getVariable "fza_sfmplus_deltaTime";
private _gndSpeed  = (_heli getVariable "fza_sfmplus_gndSpeed") * KNOTS_TO_MPS;

//Attitude hold
private _curAtt   = _heli call BIS_fnc_getPitchBank;
private _curPitch = _curAtt # 0;
private _curRoll  = _curAtt # 1;

private _attHoldCycPitchOut = 0.0;
private _attHoldCycRollOut  = 0.0;

//Position hold
if (_gndSpeed <= POS_HOLD_SPEED_SWITCH) then {
    [_heli, "fza_ah64_attHoldSubMode", "pos"] call fza_fnc_updateNetworkGlobal;
};
//Velocity hold
//This needs to check if accelerating or decelerating...really it's
//5 to 40 knots accelerating, 30 to 5 knots decelerating
if (_gndSpeed > POS_HOLD_SPEED_SWITCH && _gndSpeed <= VEL_HOLD_SPEED_SWITCH_ACCEL) then {
    [_heli, "fza_ah64_attHoldSubMode", "vel"] call fza_fnc_updateNetworkGlobal;
};
//Attitude hold
if (_gndSpeed > VEL_HOLD_SPEED_SWITCH_ACCEL) then {
    [_heli, "fza_ah64_attHoldSubMode", "att"] call fza_fnc_updateNetworkGlobal;
};

//If the attitude hold is enabled, and the force trim isn't interupted, then attitude hold is actually active
if ( _heli getVariable "fza_ah64_attHoldActive" && !(_heli getVariable "fza_ah64_forceTrimInterupted")) then {
    //Position hold
    if (_subMode == "pos") then {
        private _roll  = [_pidRoll,  _deltaTime, 0.0, -_velX] call fza_fnc_pidRun;
        _roll          = [_roll,  -1.0, 1.0] call BIS_fnc_clamp;
        private _pitch = [_pidPitch, _deltaTime, 0.0,  _velY] call fza_fnc_pidRun;
        _pitch         = [_pitch, -1.0, 1.0] call BIS_fnc_clamp;

        _attHoldCycPitchOut = _pitch;
        _attHoldCycRollOut  = _roll;
    };
    //Velocity hold
    if (_subMode == "vel") then {
        (_heli getVariable "fza_ah64_attHoldDesiredVel")
            params ["_setVelX", "_setVelY"];
        private _roll  = [_pidRoll,  _deltaTime, _setVelX, -_velX] call fza_fnc_pidRun;
        _roll          = [_roll,  -1.0, 1.0] call BIS_fnc_clamp;
        private _pitch = [_pidPitch, _deltaTime, _setVelY, _velY] call fza_fnc_pidRun;
        _pitch         = [_pitch, -1.0, 1.0] call BIS_fnc_clamp;

        _attHoldCycPitchOut = _pitch;
        _attHoldCycRollOut  = _roll;
    };
    //Attitude hold
    if (_subMode == "att") then {
       (_heli getVariable "fza_ah64_attHoldDesiredAtt")
              params ["_setPitch", "_setRoll"];
        private _pitchError = [_curPitch - _setPitch] call CBA_fnc_simplifyAngle180;
        private _rollError  = [_curRoll  - _setRoll]  call CBA_fnc_simplifyAngle180;

        private _roll  = [_pidRoll_att,  _deltaTime, 0.0, _rollError] call fza_fnc_pidRun;
        _roll          = [_roll,  -1.0, 1.0] call BIS_fnc_clamp;
        private _pitch = [_pidPitch_att, _deltaTime, 0.0, _pitchError] call fza_fnc_pidRun;
        _pitch         = [_pitch, -1.0, 1.0] call BIS_fnc_clamp;

        _attHoldCycPitchOut = _pitch * -1.0;
        _attHoldCycRollOut  = _roll  * -1.0;
    };
} else {
    //Position & Velocity hold
    [_pidRoll]  call fza_fnc_pidReset;
    [_pidPitch] call fza_fnc_pidReset;

    //Attitude hold
    [_pidRoll_att]  call fza_fnc_pidReset;
    [_pidPitch_att] call fza_fnc_pidReset;
};

//systemChat format ["Dist = %4 -- DistX = %1 -- DistY = %2 -- Dir = %3", _distX toFixed 2, _distY toFixed 2, _dir toFixed 2, _dist toFixed 2];
//systemChat format ["VelX = %1 -- VelY = %2 -- Pitch Out = %3 -- Roll Out = %4", _curVelX toFixed 2, _curVelY toFixed 2, _attHoldCycPitchOut toFixed 2, _attHoldCycRollOut toFixed 2];

[_attHoldCycPitchOut, _attHoldCycRollOut]