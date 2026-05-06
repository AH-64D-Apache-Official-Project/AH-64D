/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_init

Description:
    Initialises FCR variables for the given helicopter. Safe to call multiple times.

Parameters:
    _heli - The helicopter to initialise

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params["_heli"];

if (!(_heli getVariable ["fza_ah64_fcrInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_fcrInitialised", true, true];

    _heli setVariable ["fza_ah64_fcrState", [FCR_MODE_OFF, 0], true];
    _heli setVariable ["fza_ah64_fcrLastScan", [direction _heli, getPos _heli, 0, direction _heli], true];
    _heli setVariable ["fza_ah64_fcrTargets", [], true];
    _heli setVariable ["fza_ah64_fcrNts", [objNull,[0,0,0], []], true];
    _heli setVariable ["fza_ah64_shotat_list", [], true];
    _heli setVariable ["fza_ah64_tofCountDown", [], true];
    _heli setVariable ["fza_ah64_fcrMode", 1, true];
    _heli setVariable ["fza_ah64_fcrAzBias", 0, true];
    _heli setVariable ["fza_ah64_fcrWaitingForStart", false, true];
    _heli setVariable ["fza_ah64_fcrcscope", false, true];
};
