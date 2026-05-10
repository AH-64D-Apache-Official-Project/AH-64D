/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_weaponActionSwitch

Description:
    Sets the Weapon Action Switch (WAS) state for the requesting crew seat
    and updates the selected weapon.

Parameters:
    _heli   - The helicopter
    _weapon - New WAS state (WAS_WEAPON_NONE/GUN/RKT/MSL)

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_weapon"];

[_heli, "fza_ah64_was", _weapon] call fza_fnc_setSeatVariable;
