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

//APU
private _apuRPM_pct  = _heli getVariable "fza_sfmplus_apuRPM_pct";
//Engine 1
private _eng1State   = _heli getVariable "fza_sfmplus_engState" select 0;
private _eng1PctNP   = _heli getVariable "fza_sfmplus_engPctNP" select 0;
//Engine 2
private _eng2State   = _heli getVariable "fza_sfmplus_engState" select 1;
private _eng2PctNP   = _heli getVariable "fza_sfmplus_engPctNP" select 1;

private _priHydPumpDamage  = _heli getHitPointDamage "hit_hyd_priPump";
private _priHydPSI_pct     = _heli getVariable "fza_sfmplus_priHydPSI_pct";
private _priHydPSI         = _heli getVariable "fza_sfmplus_priHydPsi";

private _utilHydPumpDamage = _heli getHitPointDamage "hit_hyd_utilPump";
private _utilHydPSI_pct    = _heli getVariable "fza_sfmplus_utilHydPSI_pct";
private _utilHydPSI        = _heli getVariable "fza_sfmplus_utilHydPsi";

if (_apuRPM_pct > SYS_MIN_RPM - 0.35 || (_eng1State == "ON" && _eng1PctNP > SYS_MIN_RPM) || (_eng2State == "ON" && _eng2PctNP > SYS_MIN_RPM)) then {
    //Pri pump
    if (_priHydPumpDamage <= SYS_HYD_DMG_VAL) then {
        _priHydPSI_pct  = [_priHydPSI_pct,  1.0, 2.0 * _deltaTime] call BIS_fnc_lerp;
    } else {
        _priHydPSI_pct  = 0.0;
    };
    //Util pump
    if (_utilHydPumpDamage <= SYS_HYD_DMG_VAL) then {
        _utilHydPSI_pct = [_utilHydPSI_pct, 1.0, 2.0 * _deltaTime] call BIS_fnc_lerp;
    } else {
        _utilHydPSI_pct = 0.0;
    };
} else {
    _priHydPSI_pct  = [_priHydPSI_pct,  0.0, 2.0 * _deltaTime] call BIS_fnc_lerp;
    _utilHydPSI_pct = [_utilHydPSI_pct, 0.0, 2.0 * _deltaTime] call BIS_fnc_lerp;
};
_heli setVariable ["fza_sfmplus_priHydPSI_pct",  _priHydPSI_pct];
_heli setVariable ["fza_sfmplus_utilHydPSI_pct", _utilHydPSI_pct];

_priHydPSI  = _priHydPSI_pct  * 3000.0;
_utilHydPSI = _utilHydPSI_pct * 3000.0;

_heli setVariable ["fza_sfmplus_priHydPsi",   _priHydPSI];
_heli setVariable ["fza_sfmplus_utilHydPsi", _utilHydPSI];