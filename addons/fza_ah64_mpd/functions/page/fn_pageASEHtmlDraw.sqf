/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_pageASEHtmlDraw

Description:
    Sends the HTML ASE page (ui\ase\ase.js) its threat symbols and tracking lines, each payload only when it changes:
    - defs:  every point ident seen so far (fza_mpd_fnc_htmlDefsJson)
    - frame: the symbols and the tracking lines

Parameters:
    _heli     - The helicopter
    _mpdIndex - 0 left MPD, 1 right MPD
    _points   - The symbols, as fza_mpd_fnc_drawIcons takes them, at their MPD positions
    _lines    - The tracking lines, [bearing from the nose, end radius in MPD units]

Returns:
    Nothing

Examples:
    --- Code
    [_heli, _mpdIndex, _points, _lines] call fza_mpd_fnc_pageASEHtmlDraw
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
disableSerialization;
params ["_heli", "_mpdIndex", ["_points", []], ["_lines", []]];

private _ctrl = [_heli, _mpdIndex] call fza_mpd_fnc_htmlCtrl;
if (isNull _ctrl) exitWith {};

// The MPD's video underlay under the page
[_heli, _mpdIndex, ctrlParent _ctrl] call fza_mpd_fnc_videoApply;

// Drawn as the TSD draws them, its symbol size, text height and characters in (fza_mpd_fnc_threatSymbolTune)
private _pts = [_ctrl, _points, fza_mpd_threatTune getOrDefault ["tsd", MPD_THREAT_TUNE_TSD]] call fza_mpd_fnc_htmlPoints;
// A line that isn't finite numbers would lose the whole payload, as toJSON writes it as text JSON cannot parse
_lines = _lines select {_x isEqualTypeArray [0, 0] && {finite (_x # 0)} && {finite (_x # 1)}};

[_ctrl, "fzaASE.defs", [_ctrl] call fza_mpd_fnc_htmlDefsJson, "d"] call fza_mpd_fnc_htmlPush;
[_ctrl, "fzaASE.frame", format ['{"pts":%1,"lines":%2}', toJSON _pts, toJSON _lines], "f"] call fza_mpd_fnc_htmlPush;
