/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_rfiSymbol

Description:
    How an RFI threat symbol is drawn. No. 1 emitter: homeplate, dashed for search. Others: unboxed for search,
    boxed for acquisition and track. Launch flashes the box. Fine bearings have the triangle, coarse ones only the
    characters. Yellow, partial intensity when stale.

Parameters:
    _record   - fza_ah64_ase_rfiEmitters record
    _first    - whether it is the No. 1 emitter
    _selected - whether it is this crew station's selected emitter (inverse video)
    _blink    - fza_mpd_fnc_iconBlink

Returns:
    [chars, glyph, frame, colour key], see fza_mpd_fnc_rfiIdent. A selected emitter's frame is "fill" and its
    glyph and characters go over it in black.

Examples:
    [_record, true, false, false] call fza_mpd_fnc_rfiSymbol

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_record", "_first", "_selected", "_blink"];
_record params ["", "_code", "_fine", "", "_mode", "", "_stale"];

private _chars    = [_code] call fza_ase_fnc_rfiChars;
private _colorKey = ["Y", "YD"] select _stale;
if (_selected) exitWith {[_chars, ["", "solid"] select _fine, "fill", _colorKey]};

private _frame = switch (true) do {
    case (_mode >= ASE_LNC && _blink):  {""};
    case (_first && _mode == ASE_SRH): {"dash"};
    case (_first):                      {"home"};
    case (_mode >= ASE_ACQ):            {"box"};
    default                             {""};
};
[_chars, ["", "fine"] select _fine, _frame, _colorKey]
