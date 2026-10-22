/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponMissileAdvance

Description:
    Missile advance: with the crew station's missile MODE MAN and missiles
    actioned, selects the next missile of the selected type (SAL or RF) in
    firing order, round to the first after the last. It never changes the
    type (TYPE on the WPN page does). The missile selected is fired next
    (fza_fnc_weaponMissilePriority).

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Author:
    BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

if !([_heli, WAS_WEAPON_MSL] call fza_fnc_wasSeat) exitWith {};
if (([_heli, "fza_ah64_mslMode"] call fza_fnc_getSeatVariable) != MSL_MODE_MAN) exitWith {};

private _ammo      = getText (configFile >> "CfgWeapons" >> (_heli getVariable ["fza_ah64_selectedMissile", ""]) >> "fza_ammoType");
private _inventory = [_heli] call fza_fnc_weaponMissileInventory;
private _slots     = MSL_FIRING_ORDER select {(_inventory # _x) isEqualTo _ammo};
if (_slots isEqualTo []) exitWith {};

private _current = [_inventory, _ammo, _heli] call fza_fnc_weaponMissileGetSelected;
_heli setVariable ["fza_ah64_mslSlot", _slots # (((_slots find _current) + 1) mod count _slots), true];
