/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponMissilePriority

Description:
    Makes the selected missile the one fired next: the pylons keep their
    configured firing priorities, with the selected missile's above them all.
    Applied only when the selected missile changes.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Author:
    BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _ammo = getText (configFile >> "CfgWeapons" >> (_heli getVariable ["fza_ah64_selectedMissile", ""]) >> "fza_ammoType");
private _slot = [[_heli] call fza_fnc_weaponMissileInventory, _ammo, _heli] call fza_fnc_weaponMissileGetSelected;
if (_slot == (_heli getVariable ["fza_ah64_mslPriorityApplied", -2])) exitWith {};
_heli setVariable ["fza_ah64_mslPriorityApplied", _slot];

private _priorities = ("true" configClasses (configOf _heli >> "Components" >> "TransportPylonsComponent" >> "pylons")) apply {getNumber (_x >> "priority")};
if (_slot != -1) then {_priorities set [_slot, (selectMax _priorities) + 1]};
_heli setPylonsPriority _priorities;
