/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_getAccelerations

Description:


Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:


Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
//X Axis Acceleration
private _velX         = fza_sfmplus_velModelSpace select 0;
fza_sfmplus_accelX    = [fza_sfmplus_accelX_avg, (_velX - fza_sfmplus_velX_prev) / fza_sfmplus_deltaTime] call fza_sfmplus_fnc_getSmoothAverage;
fza_sfmplus_velX_prev = _velX;

//Y Axis Acceleration
private _velY         = fza_sfmplus_velModelSpace select 1;
fza_sfmplus_accelY    = [fza_sfmplus_accelY_avg, (_velY - fza_sfmplus_velY_prev) / fza_sfmplus_deltaTime] call fza_sfmplus_fnc_getSmoothAverage;
fza_sfmplus_velY_prev = _velY;

//Z Axis Acceleration
private _velZ         = fza_sfmplus_velModelSpace select 2;
fza_sfmplus_accelZ    = [fza_sfmplus_accelZ_avg, (_velZ - fza_sfmplus_velZ_prev) / fza_sfmplus_deltaTime] call fza_sfmplus_fnc_getSmoothAverage;
fza_sfmplus_velZ_prev = _velZ;