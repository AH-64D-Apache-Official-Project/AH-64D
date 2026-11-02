/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_cursorEnter

Description:
    Cursor enter: presses the VAB whose label the crew station's MPD cursor is
    on (fza_mpd_fnc_cursorPick).

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_mpd_fnc_cursorEnter
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if !(player in [driver _heli, gunner _heli]) exitWith {};
private _cursor = _heli getVariable "fza_mpd_cursor";
if (isNil "_cursor") exitWith {};
_cursor params ["_side", "_posX", "_posY"];
if (toLower ([_heli, _side] call fza_mpd_fnc_currentPage) == "off") exitWith {};

_cursor set [3, time];
_cursor set [7, -1];
// Looked for again, as the page may have changed since it was last
private _vab = [_heli, _side, _posX, _posY] call fza_mpd_fnc_cursorPick;
if (_vab < 1) exitWith {};
private _control = (["l", "r", "t", "b"] select floor ((_vab - 1) / 6)) + str ((_vab - 1) % 6 + 1);
[_heli, ["lmpd", "rmpd"] select _side, _control] call fza_fnc_coreCockpitInteract;
