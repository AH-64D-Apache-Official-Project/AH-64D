/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_getDeltaTime

Description:
    Custom time handler

Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _deltaTime     = _heli getVariable "fza_sfmplus_deltaTime_compair";
private _previousTime  = _heli getVariable "fza_sfmplus_previousTime";
private _deltaTime_avg = _heli getVariable "fza_sfmplus_deltaTime_avg";

private _currentTime = diag_tickTime;
_deltaTime           = _currentTime - _previousTime;
_previousTime        = _currentTime;

_deltaTimeout        = _deltaTime * accTime;

_heli setVariable ["fza_sfmplus_currentTime",  _currentTime];
_heli setVariable ["fza_sfmplus_previousTime", _previousTime];
_heli setVariable ["fza_sfmplus_deltaTime_compair", _deltaTime];
_heli setVariable ["fza_sfmplus_deltaTime",    _deltaTimeout];