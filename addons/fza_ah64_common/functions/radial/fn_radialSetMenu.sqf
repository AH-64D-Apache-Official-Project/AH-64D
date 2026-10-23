/* ----------------------------------------------------------------------------
Function: fza_fnc_radialSetMenu

Description:
    Shows a menu of the radial menu, its labels placed on its sectors. The
    stick has to come back to the centre before it selects anything in it.

Parameters:
    _display - The radial menu display
    _menu    - "top", "hmd", "fcr", "tads" or "lst"

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "radial.hpp"
params ["_display", "_menu"];

private _heli = _display getVariable ["fza_radialHeli", objNull];
([_heli, _menu] call fza_fnc_radialItems) params ["_items", "_hubText"];
_display setVariable ["fza_radialMenu", _menu];
_display setVariable ["fza_radialItems", _items];
_display setVariable ["fza_radialHubText", _hubText];
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
} forEach (_labels select [0, RADIAL_LABELS - 2]);

// The hub: in a sub menu what is selected, or else its name, over a line (fza_fnc_radialDraw) with BACK under it, in the
// top menu CLOSE
private _isTop = _menu == "top";
private _title = _labels param [RADIAL_LABELS - 2, controlNull];
private _hub   = _labels param [RADIAL_LABELS - 1, controlNull];
{
    _x params ["_ctrl", "_text", "_offset"];
    if (!isNull _ctrl) then {
        _ctrl ctrlSetFontHeight RADIAL_HUB_FONT;
        private _pos = ctrlPosition _ctrl;
        _ctrl ctrlSetPosition [0.5 - (_pos # 2) / 2, 0.5 - (_pos # 3) / 2 + _offset];
        _ctrl ctrlSetText _text;
        _ctrl ctrlCommit 0;
        _ctrl ctrlShow (_text != "");
    };
} forEach [
    [_title, ["", [_hubText, toUpper _menu] select (_hubText == "")] select !_isTop, -0.022],
    [_hub, ["BACK", "CLOSE"] select _isTop, [0.022, 0] select _isTop]
];
