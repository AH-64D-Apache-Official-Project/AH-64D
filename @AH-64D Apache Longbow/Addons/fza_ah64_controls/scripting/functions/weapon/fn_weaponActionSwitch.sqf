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
params["_heli", "_weapon",["_invert", false, [true]]];

private _Turret = [_heli, _invert] call fza_fnc_currentTurret;
private _sysWas = _heli getVariable "fza_ah64_was";
_sysWas set [_Turret, _weapon];

_heli setVariable ["fza_ah64_was", _sysWas, true];
if (_invert && (_heli turretunit _Turret != objnull)) exitwith {
    [_heli] remoteExec ["fza_fnc_weaponUpdateSelected", _heli turretunit _Turret];
};
[_heli] call fza_fnc_weaponUpdateSelected;