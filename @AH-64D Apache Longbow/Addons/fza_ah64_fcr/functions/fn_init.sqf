/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_eventInit

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

if (!(_heli getVariable ["fza_ah64_fcrInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_fcrInitialised", true, true];

    _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_OFF, CBA_missionTime], true];
    _heli setVariable ["fza_ah64_fcrLastScan", [direction _heli, getPos _heli, CBA_missionTime,direction _heli], true];
    _heli setVariable ["fza_ah64_fcrTargets", [], true];
    _heli setVariable ["fza_ah64_fcrNts", [objNull,[0,0,0]], true];
    _heli setVariable ["fza_ah64_shotat_list", [], true];
    _heli setVariable ["fza_ah64_tofCountDown", [], true];
    _heli setVariable ["fza_ah64_fcrMode", 1, true];
    _heli setVariable ["fza_ah64_fcrcscope", false, true];
};
