/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_hydraulicsAccumulator

Description:
    Updates all of the modules core functions.
    
Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_deltaTime"];
#include "\fza_ah64_systems\headers\systems.hpp"

private _priHydPSI     = _heli getVariable "fza_systems_priHydPsi";
private _utilHydPSI    = _heli getVariable "fza_systems_utilHydPsi";

private _accHydPSI_pct = _heli getVariable "fza_systems_accHydPSI_pct";
private _accHydPSI     = _heli getVariable "fza_systems_accHydPsi";
private _emerHydOn     = _heli getVariable "fza_ah64_emerHydOn";
private _accTimer      = _heli getVariable "fza_systems_accTimer";

if (_priHydPSI < SYS_MIN_HYD_PSI && _utilHydPSI < SYS_MIN_HYD_PSI) then {
    if (_emerHydOn) then {
        _accHydPSI_pct = [_accHydPSI_pct, 0.0, (1 / _accTimer) * _deltaTime] call BIS_fnc_lerp;
    };
};
_accHydPSI = _accHydPSI_pct  * 3000.0;

if (_accHydPSI < SYS_MIN_ACC_PSI) then {
    _emerHydOn         = false;
    _accHydPSI_pct = 0.0;
};

_heli setVariable ["fza_systems_accHydPSI_pct",  _accHydPSI_pct];
_heli setVariable ["fza_systems_accHydPsi",      _accHydPSI];
_heli setVariable ["fza_ah64_emerHydOn",          _emerHydOn];