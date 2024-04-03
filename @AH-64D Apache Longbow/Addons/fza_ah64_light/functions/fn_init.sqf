/* ----------------------------------------------------------------------------
Function: fza_light_fnc_init

Description:
    fire control radar event init

Parameters:
    _heli - the helicopter to initialise

Returns:
    Nothing

Examples:
    [_heli] spawn fza_fcr_fnc_eventInit

Author:
    Snow(dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params["_heli"];

if (!(_heli getVariable ["fza_ah64_lightInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_lightInitialised", true, true];
    
    _heli setVariable ["fza_ah64_lightSearchLight", false, true];
    _heli setVariable ["fza_ah64_lightAntiColl", false, true];
    _heli setVariable ["fza_ah64_lightPltFlood", false, true];
    _heli setVariable ["fza_ah64_lightCpgFlood", false, true];
};