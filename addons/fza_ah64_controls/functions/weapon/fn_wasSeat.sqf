/* ----------------------------------------------------------------------------
Function: fza_fnc_wasSeat

Description:
    Whether a crew station holds a weapon (fza_fnc_wasUpdate).

Parameters:
    _heli   - The helicopter
    _weapon - One of the WAS_WEAPON_xxx options in systemConstants
    _seat   - (optional, default player) The crew station, "plt"/"cpg" or a crew unit

Returns:
    True when the crew station holds the weapon

Examples:
    --- Code
    [_heli, WAS_WEAPON_RKT, "cpg"] call fza_fnc_wasSeat
    ---

Author:
    BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_weapon", ["_seat", player]];

_seat = [_heli, _seat] call fza_fnc_getSeat;
!isNil "_seat"
    && {(_heli getVariable ["fza_ah64_was", WAS_WEAPON_NONE]) == _weapon}
    && {_seat in (_heli getVariable ["fza_ah64_wasSeats", []])}
