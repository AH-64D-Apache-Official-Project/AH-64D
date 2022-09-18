/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_systemsHydraulicsAccumulator

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
#include "\fza_ah64_sfmplus\headers\systems.hpp"

private _priHydPSI     = _heli getVariable "fza_sfmplus_priHydPsi";
private _utilHydPSI    = _heli getVariable "fza_sfmplus_utilHydPsi";

private _accHydPSI_pct = _heli getVariable "fza_sfmplus_accHydPSI_pct";
private _accHydPSI     = _heli getVariable "fza_sfmplus_accHydPsi";
private _accState      = _heli getVariable "fza_sfmplus_accState";
private _accTimer      = _heli getVariable "fza_sfmplus_accTimer";

if (_priHydPSI < SYS_MIN_HYD_PSI && _utilHydPSI < SYS_MIN_HYD_PSI) then {
    _accState      = "ON";
    _accHydPSI_pct = [_accHydPSI_pct, 0.0, (1 / _accTimer) * _deltaTime] call BIS_fnc_lerp;
};

if (_accHydPSI < SYS_MIN_ACC_PSI) then {
    _accState = "OFF";
    _accHydPSI_pct = 0.0;
};
_accHydPSI  = _accHydPSI_pct  * 3000.0;

_heli setVariable ["fza_sfmplus_accHydPSI_pct",  _accHydPSI_pct];
_heli setVariable ["fza_sfmplus_accHydPsi",      _accHydPSI];
_heli setVariable ["fza_sfmplus_accState",       _accState];