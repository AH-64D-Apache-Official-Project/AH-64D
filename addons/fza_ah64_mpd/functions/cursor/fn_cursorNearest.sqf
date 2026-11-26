/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_cursorNearest

Description:
    Of the symbols a page drew, the one nearest an MPD cursor position within reach

Parameters:
    _picks   - [[x, y, id], ...], MPD units
    _posX    - Cursor X, 0 left to 1 right
    _posY    - Cursor Y, 0 top to 1 bottom
    _reachSq - (optional) squared distance the symbol must be nearer than, MPD units

Returns:
    [id, squared distance], id -1 with none in reach

Examples:
    --- Code
    [[[0.5, 0.2, 3]], 0.51, 0.2] call fza_mpd_fnc_cursorNearest
    // => [3, 0.0001]
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\cursor.h"
params ["_picks", "_posX", "_posY", ["_reachSq", MPD_CURSOR_POINT_REACH ^ 2]];

private _best = -1;
{
    _x params ["_sx", "_sy", "_id"];
    private _distance = [_sx, _sy] distanceSqr [_posX, _posY];
    if (_distance < _reachSq) then {
        _reachSq = _distance;
        _best = _id;
    };
} forEach _picks;
[_best, _reachSq]
