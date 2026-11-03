/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_cursorEnter

Description:
    Cursor enter: presses the VAB whose label the crew station's MPD cursor is
    on (fza_mpd_fnc_cursorPick). Else, on the TSD: gives a KU GRID prompt the
    cursor's map position, adds a point there on WPT or THRT ADD, or chooses
    the point it is on (fza_mpd_fnc_cursorPoint).

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
#include "\fza_ah64_ku\headers\constants.hpp"
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

((_heli getVariable "fza_mpd_mpdState") # _side) params ["_page", "", "", "", "_state", "_persistState"];
if (toLower _page != "tsd") exitWith {};
(_state get "subPageVarPage") params ["_subPage", "_variant"];

// The map position under the cursor, the inverse of where fza_mpd_fnc_uiDrawPoint draws a point
private _mapPos = {
    private _tsd = _persistState get _page;
    private _scale = 0.125 * 5 / (_tsd get "tsdScale");
    private _dx = _posX - 0.5;
    private _dy = 0.75 - 0.25 * (_tsd get "ctr") - _posY;
    private _pos = _heli getPos [sqrt (_dx ^ 2 + _dy ^ 2) / _scale, direction _heli + (_dx atan2 _dy)];
    [_pos # 0, _pos # 1, 0]
};

private _kuState = _heli getVariable ["fza_ku_state", KU_STATE_OFF];
if (_kuState != KU_STATE_OFF && {_heli getVariable ["fza_ku_prompt", ""] == "GRID"}) exitWith {
    _heli setVariable ["fza_ku_state", KU_STATE_INPUT];
    _heli setVariable ["fza_ku_input", [call _mapPos] call fza_dms_fnc_posToGrid];
    [_heli] call fza_ku_fnc_updateScreen;
};

// WPT or THRT ADD: a point of the chosen type, at the cursor, at ground level
if (_subPage in [2, 4] && {_variant == 1}) exitWith {
    if (_kuState != KU_STATE_OFF) exitWith {};
    private _type = _state get "addType";
    private _id = [_heli, _type] call fza_dms_fnc_pointNextFree;
    private _ident = ["WP", "TU", "CP", "", "TG"] select _type;
    private _pos = call _mapPos;
    if !([_heli, _id, _ident, _ident, _pos, getTerrainHeightASL _pos max 0] call fza_dms_fnc_pointCreate) exitWith {};
    _heli setVariable [["fza_mpd_tsdWptCurrentSel", "fza_mpd_tsdThrtCurrentSel"] select (_subPage == 4), _id];
    _state set ["subPageVarPage", [_subPage, 0]];
};

// A TSD point, chosen as if entered on the KU; DEL, EDT and RTE ADD go on to their pages for a chosen point
private _point = [_heli, _side, _posX, _posY] call fza_mpd_fnc_cursorPoint;
if (_point isEqualTo []) exitWith {};
[_heli] call fza_ku_fnc_clear;
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
