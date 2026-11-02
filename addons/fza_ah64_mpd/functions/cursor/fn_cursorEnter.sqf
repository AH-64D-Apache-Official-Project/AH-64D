/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_cursorEnter

Description:
    Cursor enter: presses the VAB whose label the crew station's MPD cursor is
    on (fza_mpd_fnc_cursorPick), or else chooses the TSD point it is on
    (fza_mpd_fnc_cursorPoint).

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
if (_vab > 0) exitWith {
    private _control = (["l", "r", "t", "b"] select floor ((_vab - 1) / 6)) + str ((_vab - 1) % 6 + 1);
    [_heli, ["lmpd", "rmpd"] select _side, _control] call fza_fnc_coreCockpitInteract;
};

// A TSD point, chosen as if entered on the KU; DEL, EDT and RTE ADD go on to their pages for a chosen point
private _point = [_heli, _side, _posX, _posY] call fza_mpd_fnc_cursorPoint;
if (_point isEqualTo []) exitWith {};
[_heli] call fza_ku_fnc_clear;
private _state = ((_heli getVariable "fza_mpd_mpdState") # _side) # 4;
(_state get "subPageVarPage") params ["_subPage", "_variant"];
switch (_subPage) do {
    case 2;
    case 4: {
        _heli setVariable [["fza_mpd_tsdWptCurrentSel", "fza_mpd_tsdThrtCurrentSel"] select (_subPage == 4), _point];
        if (_variant in [2, 4]) then {_state set ["subPageVarPage", [_subPage, _variant + 1]]};
    };
    case 3: {
        _heli setVariable ["fza_mpd_tsdRteCurrentSel", _point];
        _state set ["subPageVarPage", [3, 2]];
    };
};
