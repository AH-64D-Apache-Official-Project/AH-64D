/* ----------------------------------------------------------------------------
Function: fza_weapons_fnc_RocketSetSelected

Description:
    Sets the selected rocket type and updates the WPN page display.

Parameters:
    _heli  - The helicopter
    _index - Index into the rocket inventory to select

Returns:
    Nothing

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", "_index"];

private _inventory = [_heli] call fza_weapons_fnc_RocketInventory;
if ((_inventory # _index) isEqualTo []) exitWith {};

_heli setVariable ["fza_ah64_selectedRocket", _inventory # _index # 0, true];
