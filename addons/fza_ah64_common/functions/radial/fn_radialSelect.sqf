/* ----------------------------------------------------------------------------
Function: fza_fnc_radialSelect

Description:
    Selects a sector of the radial menu: its action is the crew station's
    keys pressed and released, then its menu opens if it has one, else the
    radial menu closes unless set to stay open. The hub goes back, or closes
    the top menu.

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

// "key,key>menu": the keys in turn, then the menu
private _split = _action find ">";
private _keys  = [_action, _action select [0, _split]] select (_split >= 0);
private _next  = ["", _action select [_split + 1]] select (_split >= 0);
{
    [_x, true] call fza_fnc_coreControlHandle;
    [_x, false] call fza_fnc_coreControlHandle;
} forEach (_keys splitString ",");
if (_next != "") exitWith {[_display, _next] call fza_fnc_radialSetMenu};
if !(missionNamespace getVariable ["fza_ah64_radialKeepOpen", false]) then {_display closeDisplay 2};
