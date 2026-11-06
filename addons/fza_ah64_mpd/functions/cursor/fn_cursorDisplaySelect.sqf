/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_cursorDisplaySelect

Description:
    Cursor display select: moves the crew station's MPD cursor to the centre
    of the other MPD, unless that one is off.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_mpd_fnc_cursorDisplaySelect
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if !(player in [driver _heli, gunner _heli]) exitWith {};
private _cursor = _heli getVariable "fza_mpd_cursor";
if (isNil "_cursor") exitWith {};
private _other = 1 - (_cursor # 0);
if (toLower ([_heli, _other] call fza_mpd_fnc_currentPage) == "off") exitWith {};

_cursor set [0, _other];
_cursor set [1, 0.5];
_cursor set [2, 0.5];
_cursor set [3, time];
_cursor set [5, false];
_cursor set [6, 0];
_cursor set [8, []];
_cursor set [7, -1];
