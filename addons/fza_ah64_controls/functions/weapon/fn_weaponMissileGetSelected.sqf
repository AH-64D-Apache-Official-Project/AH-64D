/* ----------------------------------------------------------------------------
Function: fza_fnc_weaponMissileGetSelected

Description:
    The missile position that fires next with the given ammo type selected:
    with the missile MODE of the crew station driving the missiles MAN, the
    missile it advanced to (fza_fnc_weaponMissileAdvance) while one of that
    type is there; otherwise the first of the type in firing order
    (MSL_FIRING_ORDER).

Parameters:
    _inventory - The missile inventory (fza_fnc_weaponMissileInventory)
    _ammo      - The ammo type
    _heli      - (optional) The helicopter, for a missile selected in MAN

Returns:
    The pylon slot 0-15, -1 with none of the type

Examples:
    --- Code
    [[_heli] call fza_fnc_weaponMissileInventory, "fza_agm114l", _heli] call fza_fnc_weaponMissileGetSelected
    ---

Author:
    mattysmith22, BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_inventory", "_ammo", ["_heli", objNull]];

private _manual = -1;
if (!isNull _heli) then {
    private _seat = _heli getVariable ["fza_ah64_wasDriver", ""];
    if (_seat == "") then {_seat = [_heli] call fza_fnc_getSeat};
    if (!isNil "_seat" && {(_heli getVariable ["fza_ah64_mslMode_" + _seat, MSL_MODE_NORM]) == MSL_MODE_MAN}) then {
        _manual = _heli getVariable ["fza_ah64_mslSlot", -1];
    };
};
if (_manual != -1 && {(_inventory # _manual) isEqualTo _ammo}) exitWith {_manual};

private _order = MSL_FIRING_ORDER;
private _index = _order findIf {_inventory # _x isEqualTo _ammo};
if (_index == -1) exitWith {-1};
_order # _index
