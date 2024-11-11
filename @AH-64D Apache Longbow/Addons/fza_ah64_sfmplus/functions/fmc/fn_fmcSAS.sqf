params ["_heli", "_deltaTime"];
#include "\fza_ah64_sfmplus\headers\core.hpp"

private _pidSASPitch  = _heli getVariable "fza_sfmplus_pid_sas_pitch";
//_pidSASPitch set ["kp", P_KP];
//_pidSASPitch set ["ki", P_KI];
//_pidSASPitch set ["kd", P_KD];
private _pidSASRoll   = _heli getVariable "fza_sfmplus_pid_sas_roll";
//_pidSASRoll set ["kp", R_KP];
//_pidSASRoll set ["ki", R_KI];
//_pidSASRoll set ["kd", R_KD];

([_heli, fza_ah64_sfmplusEnableWind] call fza_sfmplus_fnc_getVelocities)   //<-- needs wind enabled flag
    params [ 
             "_gndSpeed"
           , "_vel2D"
           , "_vel3D"
           , "_vertVel"
           , "_velModelSpace"
           , "_angVelModelSpace"
           , "_velWorldSpace"
           , "_angVelWorldSpace"
           ];

(_angVelModelSpace)
    params [
             "_angVelX"
           , "_angVelY"
           , "_angVelZ"
           ];

private _curAtt   = _heli call BIS_fnc_getPitchBank;
private _curPitch = _curAtt # 0;
private _curRoll  = _curAtt # 1;

private _SASPitchOutput = 0.0;
private _SASRollOutput  = 0.0;

if (!(_heli getVariable "fza_ah64_attHoldActive") && !(_heli getVariable "fza_ah64_forceTrimInterupted")) then {
    //Pitch & Roll SAS
    private _roll  = [_pidSASRoll, _deltaTime,  0.0, _angVelY] call fza_fnc_pidRun;
    _roll          = [_roll,  -1.0, 1.0] call BIS_fnc_clamp;
    private _pitch = [_pidSASPitch, _deltaTime, 0.0, _angVelX] call fza_fnc_pidRun;
    _pitch         = [_pitch, -1.0, 1.0] call BIS_fnc_clamp;

    _SASPitchOutput = _pitch;
    _SASRollOutput  = _roll;
 } else {
    [_pidSASRoll]  call fza_fnc_pidReset;
    [_pidSASPitch] call fza_fnc_pidReset;
 };


private _SASYawOutput   = 0.0;//[_pidSASRoll,  _deltaTime, 0.0, _angVelY] call fza_fnc_pidRun;

//systemChat format ["Pitch SAS = %1 -- Roll SAS = %2", _SASPitchOutput, _SASRollOutput];
//systemChat format ["_angVelX = %1 - _angVelY = %2 - _angVelZ = %3", _angVelX, _angVelY, _angVelZ];

[_SASPitchOutput, _SASRollOutput, _SASYawOutput];