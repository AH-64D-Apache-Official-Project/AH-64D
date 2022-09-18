/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_systemsHydraulicsUtilPump

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

private _utilHydPumpDamage = _heli getHitPointDamage "hit_hyd_utilPump";
private _utilHydPSI_pct    = _heli getVariable "fza_sfmplus_utilHydPSI_pct";
private _utilHydPSI        = _heli getVariable "fza_sfmplus_utilHydPsi";

if (_utilHydPumpDamage > SYS_HYD_DMG_VAL) then {
    _utilHydPSI_pct = 0.0;
} else {
    _utilHydPSI_pct = 1.0;
};
_utilHydPSI = _utilHydPSI_pct * 3000.0;

if (_utilHydPSI < SYS_MIN_HYD_PSI) then {
    //CALL WCA here
};

_heli setVariable ["fza_sfmplus_utilHydPSI_pct", _utilHydPSI_pct];
_heli setVariable ["fza_sfmplus_utilHydPsi",     _utilHydPSI];