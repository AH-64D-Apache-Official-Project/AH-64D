/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_releaseOwner

Description:
    A crew station gives up the FCR: if it owns it, its scan stops and the FCR
    has no owner.

Parameters:
    _heli - The helicopter
    _seat - The crew station, "plt" or "cpg"

Returns:
    Nothing

Examples:
    [_heli, "cpg"] call fza_fcr_fnc_releaseOwner

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", ["_seat", ""]];

if (_seat == "" || {FCR_OWNER(_heli) != _seat}) exitWith {};

[_heli] call fza_fcr_fnc_stopScan;
_heli setVariable ["fza_ah64_fcrOwner", "", true];
