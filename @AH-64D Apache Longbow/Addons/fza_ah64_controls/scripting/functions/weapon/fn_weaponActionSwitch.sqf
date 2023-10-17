/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponActionSwitch

Description:
    Switches the player between different weapon types

Parameters:
    _heli - The helicopter to act upon
    _weapon - One of the WAS_WEAPON_xxx options in systemConstants

Returns:
    Nothing

Examples:
    --- Code
    [_heli, WAS_WEAPON_GUN] call fza_fnc_weaponActionSwitch
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params["_heli", "_weapon","_invert"];

private _curTurret = [_heli, _invert] call fza_fnc_currentTurret;
private _sysWas    = _heli getVariable "fza_ah64_was";
_sysWas set [_curTurret, _weapon];

_heli setVariable ["fza_ah64_was", _sysWas, true];
[_heli] call fza_fnc_weaponUpdateSelected;