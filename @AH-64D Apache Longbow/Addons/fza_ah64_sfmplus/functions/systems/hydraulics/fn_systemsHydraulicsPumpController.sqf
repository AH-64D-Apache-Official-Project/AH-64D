/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_systemsHydraulicsPump

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

//Primary system
private _priHydPumpDamage  = _heli getHitPointDamage "hit_hyd_priPump";
private _priHydPSI_pct     = _heli getVariable "fza_sfmplus_priHydPSI_pct";
private _priHydPSI         = _heli getVariable "fza_sfmplus_priHydPsi";
//Utility system
private _utilHydPumpDamage = _heli getHitPointDamage "hit_hyd_utilPump";
private _utilHydPSI_pct    = _heli getVariable "fza_sfmplus_utilHydPSI_pct";
private _utilHydPSI        = _heli getVariable "fza_sfmplus_utilHydPsi";
//Accumulator
private _accHydPSI_pct     = _heli getVariable "fza_sfmplus_accHydPSI_pct";
private _accHydPSI         = _heli getVariable "fza_sfmplus_accHydPsi";
private _accState          = _heli getVariable "fza_sfmplus_accState";
private _accTimer          = _heli getVariable "fza_sfmplus_accTimer";

//--Pri pump
if (_priHydPumpDamage > SYS_HYD_DMG_VAL) then {
    _priHydPSI_pct  = 0.0;
};
_priHydPSI  = _priHydPSI_pct  * 3000.0;

//--Util pump
if (_utilHydPumpDamage > SYS_HYD_DMG_VAL) then {
    _utilHydPSI_pct = 0.0;
};
_utilHydPSI = _utilHydPSI_pct * 3000.0;

//--Accumulator
if (_priHydPSI < SYS_MIN_HYD_PSI && _utilHydPSI < SYS_MIN_HYD_PSI) then {
    _accState      = "ON";
    _accHydPSI_pct = [_accHydPSI_pct, 0.0, (1 / _accTimer) * _deltaTime] call BIS_fnc_lerp;
};

if (_accHydPSI < SYS_MIN_ACC_PSI) then {
    _accState = "OFF";
    _accHydPSI_pct = 0.0;
};
_accHydPSI  = _accHydPSI_pct  * 3000.0;

//Set primary system variables
_heli setVariable ["fza_sfmplus_priHydPSI_pct",  _priHydPSI_pct];
_heli setVariable ["fza_sfmplus_priHydPsi",      _priHydPSI];
//Set utility system variables
_heli setVariable ["fza_sfmplus_utilHydPSI_pct", _utilHydPSI_pct];
_heli setVariable ["fza_sfmplus_utilHydPsi",     _utilHydPSI];
//Set accumulator variables
_heli setVariable ["fza_sfmplus_accHydPSI_pct",  _accHydPSI_pct];
_heli setVariable ["fza_sfmplus_accHydPsi",      _accHydPSI];
_heli setVariable ["fza_sfmplus_accState",       _accState];