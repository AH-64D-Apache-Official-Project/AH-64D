/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_getWasSeat

Description:
    Returns which crew seat currently has the given WAS weapon type selected.
    CPG is checked first - when both seats hold the same type (rockets),
    CPG is the pylon authority.

Parameters:
    _heli    - The helicopter
    _wasType - WAS weapon constant to look for (WAS_WEAPON_GUN/RKT/MSL)

Returns:
    String - "cpg", "plt", or "" (neither seat has that WAS type)

Examples:
    private _seat = [_heli, WAS_WEAPON_GUN] call fza_weapons_fnc_getWasSeat;
    if (_seat == "") exitWith {};

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_wasType"];

if ((_heli getVariable ["fza_ah64_was_cpg", WAS_WEAPON_NONE]) == _wasType) exitWith { "cpg" };
if ((_heli getVariable ["fza_ah64_was_plt", WAS_WEAPON_NONE]) == _wasType) exitWith { "plt" };
""
