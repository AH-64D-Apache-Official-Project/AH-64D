/* ----------------------------------------------------------------------------
Function: fza_fnc_radialSetMenu

Description:
    Shows a menu of the radial menu, its labels placed on its sectors. The
    stick has to come back to the centre before it selects anything in it.

Parameters:
    _display - The radial menu display
    _menu    - "top", "fcr", "tads" or "sensors"

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "radial.hpp"
params ["_display", "_menu"];

private _heli = _display getVariable ["fza_radialHeli", objNull];
private _items = [_heli, _menu] call fza_fnc_radialItems;
_display setVariable ["fza_radialMenu", _menu];
_display setVariable ["fza_radialItems", _items];
_display setVariable ["fza_radialDwell", [RADIAL_NONE, 0, 0]];
_display setVariable ["fza_radialStickLatch", true];

// A length on screen is pixelW / pixelH times longer in x than in y
private _k = pixelW / pixelH;
private _labels = _display getVariable ["fza_radialLabels", []];
{
    private _ctrl = _x;
    private _item = _items param [_forEachIndex, []];
    if (_item isEqualTo []) then {
        _ctrl ctrlShow false;
    } else {
        _item params ["_label", "_from", "_to"];
        private _mid = (_from + _to) / 2;
        private _pos = ctrlPosition _ctrl;
        _ctrl ctrlSetPosition [
            0.5 + _k * RADIAL_R_TEXT * sin _mid - (_pos # 2) / 2,
            0.5 - RADIAL_R_TEXT * cos _mid - (_pos # 3) / 2
        ];
        _ctrl ctrlSetText _label;
        _ctrl ctrlCommit 0;
        _ctrl ctrlShow true;
    };
} forEach (_labels select [0, RADIAL_LABELS - 1]);

// The last label is the hub's
private _hub = _labels param [RADIAL_LABELS - 1, controlNull];
if (!isNull _hub) then {
    private _pos = ctrlPosition _hub;
    _hub ctrlSetPosition [0.5 - (_pos # 2) / 2, 0.5 - (_pos # 3) / 2];
    _hub ctrlSetText (["BACK", "CLOSE"] select (_menu == "top"));
    _hub ctrlCommit 0;
    _hub ctrlShow true;
};
