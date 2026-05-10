/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_MissileGetSelected

Description:
    Returns the firing-priority index of the selected missile ammo type within
    the missile inventory array. Uses the real AH-64D outboard-first priority.

Parameters:
    _inventory - Array returned by fza_weapons_fnc_MissileInventory
    _ammo      - Ammo classname to locate (e.g. "fza_agm114k")

Returns:
    Number - 0-based index into the inventory, or -1 if not found

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_inventory", "_ammo"];

_priorities = [0,12,1,13,2,14,3,15,4,8,5,9,6,10,7,11];
_index = _priorities findIf {_inventory # _x isEqualTo _ammo};

if (_index == -1) exitWith {-1};
_priorities # _index
