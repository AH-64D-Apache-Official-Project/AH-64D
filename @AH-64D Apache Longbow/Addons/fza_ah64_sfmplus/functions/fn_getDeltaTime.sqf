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

private _deltaTime     = _heli getVariable "fza_sfmplus_deltaTime";
private _previousTime  = _heli getVariable "fza_sfmplus_previousTime";
private _deltaTime_avg = _heli getVariable "fza_sfmplus_deltaTime_avg";

if (isGamePaused) exitWith { _deltaTime = 0.0; };

private _currentTime = diag_tickTime;

_deltaTime    = [_deltaTime_avg, (_currentTime - _previousTime)] call fza_sfmplus_fnc_getSmoothAverage;
_previousTime = _currentTime;

if (_deltaTime > (1.0 / 5.0)) then { _deltaTime = (1.0 / 5.0)};
_deltaTime    = _deltaTime * accTime;

_heli setVariable ["fza_sfmplus_currentTime",  _currentTime];
_heli setVariable ["fza_sfmplus_previousTime", _previousTime];
_heli setVariable ["fza_sfmplus_deltaTime",    _deltaTime];