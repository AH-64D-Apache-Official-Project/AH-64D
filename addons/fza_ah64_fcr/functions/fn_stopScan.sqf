/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_stopScan

Description:
    Stops a single or continuous FCR scan: the radar stops transmitting and the
    antenna returns to the centerline. Nothing when no scan is running.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Examples:
    [_heli] call fza_fcr_fnc_stopScan

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

if !(((_heli getVariable ["fza_ah64_fcrState", [FCR_MODE_OFF]]) # 0) in [FCR_MODE_ON_SINGLE, FCR_MODE_ON_CONTINUOUS]) exitWith {};

[_heli, false] call fza_fcr_fnc_radarSet;
_heli setVariable ["fza_ah64_fcrWaitingForStart", false, true];
_heli setVariable ["fza_ah64_fcrState", [FCR_MODE_OFF, CBA_missionTime], true];
