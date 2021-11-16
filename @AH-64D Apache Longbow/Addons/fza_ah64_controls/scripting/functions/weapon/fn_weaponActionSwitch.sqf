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
	Mattysmith22
---------------------------------------------------------------------------- */
params["_heli", "_weapon"];

if !(_heli turretLocal [0]) exitWith {};

_heli setVariable ["fza_ah64_was", _weapon, true];
_heli setVariable ["fza_ah64_wpnPageSelected", _weapon, true];
[_heli] call fza_fnc_weaponUpdateSelected;