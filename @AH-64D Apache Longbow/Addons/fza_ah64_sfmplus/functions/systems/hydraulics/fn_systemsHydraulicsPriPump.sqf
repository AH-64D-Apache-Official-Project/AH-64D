/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_systemsHydraulicsPriPump

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
params ["_heli"];
#include "\fza_ah64_sfmplus\headers\systems.hpp"

private _priHydPumpDamage = _heli getHitPointDamage "hit_hyd_priPump";
private _priHydPSI_pct    = _heli getVariable "fza_sfmplus_priHydPSI_pct";
private _priHydPSI        = _heli getVariable "fza_sfmplus_priHydPsi";

if (_priHydPumpDamage > SYS_HYD_DMG_VAL) then {
    _priHydPSI_pct = 0.0;
} else {
    _priHydPSI_pct = 1.0; 
};
_priHydPSI  = _priHydPSI_pct  * 3000.0;

if (_priHydPSI < SYS_MIN_HYD_PSI) then {
    //CALL WCA here
};

_heli setVariable ["fza_sfmplus_priHydPSI_pct",  _priHydPSI_pct];
_heli setVariable ["fza_sfmplus_priHydPsi",      _priHydPSI];