/* ----------------------------------------------------------------------------
Function: fza_fnc_radialSelect

Description:
    Selects a sector of the radial menu: a sub menu opens, an action is the
    crew station's key pressed and released, after which the menu closes
    unless set to stay open. The hub goes back, or closes the top menu.

Parameters:
    _display - The radial menu display
    _index   - The sector, RADIAL_HUB for the hub

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "radial.hpp"
params ["_display", "_index"];

if (isNull _display) exitWith {};
private _menu = _display getVariable ["fza_radialMenu", "top"];

if (_index == RADIAL_HUB) exitWith {
    if (_menu == "top") then {_display closeDisplay 2} else {[_display, "top"] call fza_fnc_radialSetMenu};
};

private _item = (_display getVariable ["fza_radialItems", []]) param [_index, []];
if (_item isEqualTo [] || {!(_item # 3)}) exitWith {};
private _action = _item # 5;

if (_action select [0, 5] == "menu:") exitWith {
    [_display, _action select [5]] call fza_fnc_radialSetMenu;
};

[_action, true] call fza_fnc_coreControlHandle;
[_action, false] call fza_fnc_coreControlHandle;
if !(missionNamespace getVariable ["fza_ah64_radialKeepOpen", false]) then {_display closeDisplay 2};
