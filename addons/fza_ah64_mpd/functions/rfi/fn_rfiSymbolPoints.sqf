/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_rfiSymbolPoints

Description:
    An RFI emitter's threat symbol as MPD screen points, as the ASE page, TSD and FCR draw it. The selected emitter is
    in inverse video: a filled homeplate, the symbol in black over it.

Parameters:
    _record   - the emitter's fza_ah64_ase_rfiEmitters record
    _index    - its index in fza_ah64_ase_rfiEmitters, 0 the No. 1 emitter
    _selected - whether it is the crew station's selected emitter
    _blink    - fza_mpd_fnc_iconBlink now
    _pos      - [x, y] on the MPD

Returns:
    [point, ...]

Examples:
    [_record, 0, false, [] call fza_mpd_fnc_iconBlink, [0.5, 0.2]] call fza_mpd_fnc_rfiSymbolPoints

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_dms\headers\constants.h"
params ["_record", "_index", "_selected", "_blink", "_pos"];

([_record, _index == 0, _selected, _blink] call fza_mpd_fnc_rfiSymbol) params ["_chars", "_glyph", "_frame", "_colorKey"];
private _screen = [_pos # 0, _pos # 1, 0];
private _id = [POINT_TYPE_RFI, _index];
if (_selected) exitWith {[
    [MPD_POSMODE_SCREEN, _screen, "", POINT_TYPE_RFI, _id, [_chars, _glyph, "fill", _colorKey, true] call fza_mpd_fnc_rfiIdent],
    [MPD_POSMODE_SCREEN, _screen, "", POINT_TYPE_RFI, _id, [_chars, _glyph, "", "K"] call fza_mpd_fnc_rfiIdent]
]};
[[MPD_POSMODE_SCREEN, _screen, "", POINT_TYPE_RFI, _id, [_chars, _glyph, _frame, _colorKey] call fza_mpd_fnc_rfiIdent]]
