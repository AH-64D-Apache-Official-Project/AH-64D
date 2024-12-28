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
fza_sfmplus_accelX    = (_velX - fza_sfmplus_velX_prev) / fza_sfmplus_deltaTime;
[fza_sfmplus_accelX_avg, fza_sfmplus_accelX] call fza_sfmplus_fnc_smoothAverageAdd;
fza_sfmplus_accelX    = [fza_sfmplus_accelX_avg] call fza_sfmplus_fnc_smoothAverageGet;
fza_sfmplus_velX_prev = _velX;

//Y Axis Acceleration
private _velY         = fza_sfmplus_velModelSpace select 1;
fza_sfmplus_accelY    = (_velY - fza_sfmplus_velY_prev) / fza_sfmplus_deltaTime;
[fza_sfmplus_accelY_avg, fza_sfmplus_accelY] call fza_sfmplus_fnc_smoothAverageAdd;
fza_sfmplus_accelY    = [fza_sfmplus_accelY_avg] call fza_sfmplus_fnc_smoothAverageGet;
fza_sfmplus_velY_prev = _velY;

//Z Axis Acceleration
private _velZ         = fza_sfmplus_velModelSpace select 2;
fza_sfmplus_accelZ    = (_velZ - fza_sfmplus_velZ_prev) / fza_sfmplus_deltaTime;
[fza_sfmplus_accelZ_avg, fza_sfmplus_accelZ] call fza_sfmplus_fnc_smoothAverageAdd;
fza_sfmplus_accelZ    = [fza_sfmplus_accelZ_avg] call fza_sfmplus_fnc_smoothAverageGet;
fza_sfmplus_velZ_prev = _velZ;