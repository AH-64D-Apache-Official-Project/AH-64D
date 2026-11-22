/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_singleScan

Description:
    Starts one scanburst, as the scan switch: not on the ground without ground override, nor with the FCR failed

Parameters:
    _heli - The helicopter

Returns:
    True when the scanburst started

Examples:
    [_heli] call fza_fcr_fnc_singleScan

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

if ((([_heli] call bmkhs_fnc_stateOnGround) && {!(_heli getVariable ["fza_ah64_gndOrideOn", false])})
    || {((_heli getVariable ["fza_ah64_fcrState", [FCR_MODE_OFF]]) # 0) == FCR_MODE_FAULT}) exitWith {false};
[_heli, true] call fza_fcr_fnc_radarSet;
[_heli, FCR_MODE_ON_SINGLE] call fza_fcr_fnc_armScanStart;
_heli setVariable ["fza_ah64_fcrTargets", [], true];
true
