params ["_heli"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

private _pidSASPitch = _heli getVariable "fza_sfmplus_pid_sas_pitch";
//_pidSASPitch set ["kp", P_KP];
//_pidSASPitch set ["ki", P_KI];
//_pidSASPitch set ["kd", P_KD];
private _pidSASRoll  = _heli getVariable "fza_sfmplus_pid_sas_roll";
//_pidSASRoll set ["kp", R_KP];
//_pidSASRoll set ["ki", R_KI];
//_pidSASRoll set ["kd", R_KD];
private _pidSASYaw   = _heli getVariable "fza_sfmplus_pid_sas_yaw";
//_pidSASRoll set ["kp", Y_KP];
//_pidSASRoll set ["ki", Y_KI];
//_pidSASRoll set ["kd", Y_KD];

(fza_sfmplus_angVelModelSpace)
    params [
             "_angVelX"
           , "_angVelY"
           , "_angVelZ"
           ];

private _sasPitchOutput = 0.0;
private _sasRollOutput  = 0.0;
private _sasYawOutput   = 0.0;

if (!(_heli getVariable "fza_ah64_attHoldActive") && !(_heli getVariable "fza_ah64_forceTrimInterupted")) then {
    //Pitch & Roll SAS
    private _roll  = [_pidSASRoll, fza_sfmplus_deltaTime,  0.0, _angVelY] call fza_fnc_pidRun;
    _roll          = [_roll,  -1.0, 1.0] call BIS_fnc_clamp;
    private _pitch = [_pidSASPitch, fza_sfmplus_deltaTime, 0.0, _angVelX] call fza_fnc_pidRun;
    _pitch         = [_pitch, -1.0, 1.0] call BIS_fnc_clamp;
    private _yaw   = [_pidSASYaw,  fza_sfmplus_deltaTime,  0.0, _angVelZ] call fza_fnc_pidRun;
    _yaw           = [_yaw, -1.0, 1.0] call BIS_fnc_clamp;

    _sasPitchOutput = _pitch;
    _sasRollOutput  = _roll;
    _sasYawOutput   = 0.0;
 } else {
    [_pidSASRoll]  call fza_fnc_pidReset;
    [_pidSASPitch] call fza_fnc_pidReset;
    [_pidSASYaw]   call fza_fnc_pidReset;
 };


//systemChat format ["Pitch SAS = %1 -- Roll SAS = %2", _SASPitchOutput, _SASRollOutput];
//systemChat format ["_angVelX = %1 - _angVelY = %2 - _angVelZ = %3", _angVelX, _angVelY, _angVelZ];

[_sasPitchOutput, _sasRollOutput, _sasYawOutput];