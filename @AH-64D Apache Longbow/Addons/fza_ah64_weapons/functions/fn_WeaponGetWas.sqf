/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_WeaponGetWas

Description:
    
Parameters:

Returns:

Examples:
    _return = [_heli] call fza_weapons_fnc_WeaponGetWas;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params["_heli",["_invert", false, [true]]];

private _curTurret = [_heli, _invert] call fza_fnc_currentTurret;
(_heli getVariable "fza_ah64_was") get _curTurret;