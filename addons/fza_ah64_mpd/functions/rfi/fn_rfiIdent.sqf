/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_rfiIdent

Description:
    The point ident of an RFI threat symbol, registered in fza_dms_pointIdents the first time it is asked for, so
    the native MPD pages and the HTML TSD draw it like a config icon. The layout follows the characters: fine, they sit
    at the triangle's upper left and right, one alone at its upper right with the triangle moved left; coarse, they are
    together in the middle. The frame is fitted to it (tools/generate_rfi_icons.py).

Parameters:
    _chars     - [left, right] type modifier characters
    _glyph     - "" (coarse), "fine" (open triangle) or "solid" (filled triangle)
    _frame     - "", "box", "home", "dash" (homeplate dashed) or "fill" (homeplate filled)
    _colorKey  - "Y", "YD" (yellow, dim) or "K" (black)
    _frameOnly - (optional) only the frame, laid out for _chars and _glyph: the selected emitter's background

Returns:
    Ident

Examples:
    [["", "6"], "fine", "home", "Y"] call fza_mpd_fnc_rfiIdent

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_dms\headers\constants.h"
params ["_chars", "_glyph", "_frame", "_colorKey", ["_frameOnly", false]];

private _ident = format ["RFI_%1_%2_%3_%4_%5_%6", _chars # 0, _chars # 1, _glyph, _frame, _colorKey, _frameOnly];
if (_ident in fza_dms_pointIdents) exitWith {_ident};

// One character always goes in the right-hand place
private _single = (_chars # 0) == "" || {(_chars # 1) == ""};
private _right  = [_chars # 1, _chars # 0] select ((_chars # 1) == "");
private _layout = (["c", "f"] select (_glyph != "")) + (["2", "1"] select _single);
private _texOf  = {
    params ["_kind"];
    if (_kind == "") exitWith {""};
    format ["\fza_ah64_mpd\tex\aseIcons\rfi_%1_%2_ca.paa", _kind, _layout]
};
private _texts = switch (_layout) do {
    case "f2": {[[_chars # 0, [0.135, 0.33], "left", "center"], [_chars # 1, [0.865, 0.33], "right", "center"]]};
    case "f1": {[["", [0, 0], "left", "center"], [_right, [0.826, 0.33], "right", "center"]]};
    case "c2": {[[_chars # 0, [0.484, 0.5], "right", "center"], [_chars # 1, [0.516, 0.5], "left", "center"]]};
    default    {[["", [0, 0], "left", "center"], [_right, [0.5, 0.5], "center", "center"]]};
};
if (_frameOnly) then {_texts = [["", [0, 0], "left", "center"], ["", [0, 0], "left", "center"]]};

private _color = createHashMapFromArray [
    ["Y",  [1, 1, 0, 1]],
    ["YD", [0.55, 0.55, 0, 1]],
    ["K",  [0, 0, 0, 1]]
];
private _glyphTex = [[["tri", "sol"] select (_glyph == "solid")] call _texOf, ""] select (_glyph == "" || _frameOnly);
fza_dms_pointIdents set [_ident, [_glyphTex, [_frame] call _texOf, 0.09, _color get _colorKey,
    _texts # 0, _texts # 1, POINT_TYPE_RFI]];
_ident
