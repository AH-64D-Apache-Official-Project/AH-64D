/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_cursorEnter

Description:
    Cursor enter: presses the VAB whose label the crew station's MPD cursor is
    on (fza_mpd_fnc_cursorPick). Else:
    - FCR formats: zooms on the area while ZOOM is choosing one, or, with FCR
      as the crew station's sight, stores the target symbol it is on while TGT
      is selected, else makes it the NTS.
    - TSD: gives a KU GRID prompt the cursor's map position, pans the map
      there on the PAN page, makes the point or FCR target it is on the
      acquisition source while CAQ is choosing, adds a point there on WPT or
      THRT ADD, or chooses the point it is on (fza_mpd_fnc_cursorPoint).

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
#include "\fza_ah64_controls\headers\systemConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_mpd\headers\cursor.h"
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
    // Held while cursor enter is (fza_mpd_fnc_cursorUpdate)
    _heli setVariable ["fza_mpd_hold", nil];
    _heli setVariable ["fza_mpd_cursorHeld", [_side, _control, _vab]];
};

((_heli getVariable "fza_mpd_mpdState") # _side) params ["_page", "", "", "", "_state", "_persistState"];

// A target as the FCR's NTS, with its record in the target file (fza_fcr_fnc_cycleNTS)
private _setNts = {
    params ["_target", "_pos"];
    // Not one in an active NF zone
    private _display = _heli getVariable ["fza_ah64_fcrDisplayTargets", []];
    if (((_display param [_display findIf {(_x # 3) isEqualTo _target}, []]) param [7, 0]) == 2) exitWith {};
    private _file = _heli getVariable ["fza_ah64_fcrTargets", []];
    private _rec  = _file param [_file findIf {(_x # 3) isEqualTo _target}, []];
    [_heli, "fza_ah64_fcrNts", [_target, _pos, _rec]] call fza_fnc_updateNetworkGlobal;
};

if (toLower _page in ["fcr", "fcrrmap"]) exitWith {
    if !([_heli, _side, _posX, _posY] call fza_mpd_fnc_cursorInArea) exitWith {};
    // ZOOM: the zoom box's area, sized by the scan size, shown in the zoomed square
    if (_state getOrDefault ["zoom", 0] == 1) exitWith {
        private _half = [MPD_CURSOR_ZOOM_HALF_W, MPD_CURSOR_ZOOM_HALF_M, MPD_CURSOR_ZOOM_HALF_N, MPD_CURSOR_ZOOM_HALF_Z] param [_heli getVariable ["fza_ah64_fcrScanSize", 0], MPD_CURSOR_ZOOM_HALF_W];
        _state set ["zoomCtr", [_posX, _posY]];
        _state set ["zoomRatio", MPD_CURSOR_ZOOM_VIEW_HALF / _half];
        _state set ["zoom", 2];
    };
    // A target symbol (fza_mpd_fnc_fcrGTMDraw, fza_mpd_fnc_fcrATMDraw, fza_mpd_fnc_fcrRMAPDraw): stored while TGT is
    // selected, else the NTS, as the NTS button selects one
    // The one the cursor shows it is on, found again now
    [_heli, _side, _state, _state getOrDefault ["cursorTargets", []]] call fza_mpd_fnc_fcrCursorHover;
    private _best = _state getOrDefault ["cursorHover", []];
    if (_best isEqualTo []) exitWith {};
    if (_state getOrDefault ["tgt", 0] == 1) exitWith {[_heli, _state, [[_best # 3, _best # 2]]] call fza_mpd_fnc_fcrTgtStore};
    [_best # 2, _best # 3] call _setNts;
};

if (toLower _page != "tsd") exitWith {};
if !([_heli, _side, _posX, _posY] call fza_mpd_fnc_cursorInArea) exitWith {};
(_state get "subPageVarPage") params ["_subPage", "_variant"];

// The map position under an MPD position, the inverse of where fza_mpd_fnc_uiDrawPoint draws a point
private _mapPos = {
    params ["_px", "_py"];
    private _tsd = _persistState get _page;
    ([_heli, _tsd] call fza_mpd_fnc_tsdFrame) params ["_framePos", "_frameHeading"];
    [_framePos, _frameHeading, [_tsd] call fza_mpd_fnc_tsdScale, [0.5, 0.75 - 0.25 * (_tsd get "ctr")], [_px, _py]] call fza_mpd_fnc_tsdScreenToWorld
};

private _kuState = _heli getVariable ["fza_ku_state", KU_STATE_OFF];
if (_kuState != KU_STATE_OFF && {_heli getVariable ["fza_ku_prompt", ""] == "GRID"}) exitWith {
    _heli setVariable ["fza_ku_state", KU_STATE_INPUT];
    _heli setVariable ["fza_ku_input", [[_posX, _posY] call _mapPos] call fza_dms_fnc_posToGrid];
    [_heli] call fza_ku_fnc_updateScreen;
};

// PAN: the frozen map moved so the place under the cursor is at its centre, at the same heading
if (_subPage == 5) exitWith {
    private _tsd = _persistState get _page;
    private _frame = [[_posX, _posY + 0.25 - 0.25 * (_tsd get "ctr")] call _mapPos, ([_heli, _tsd] call fza_mpd_fnc_tsdFrame) # 1];
    _tsd set ["frozen", _frame];
    _tsd set ["lastPan", +_frame];
    _tsd set ["panRte", -1];
};

// CAQ, the map staying frozen: as the crew station's acquisition source, the point under the cursor, or an FCR target
// stored as T50
if (_subPage == 0 && {_state getOrDefault ["caq", 0] == 1}) exitWith {
    // Chosen while CAQ is still selected, as fza_mpd_fnc_cursorPoint offers points only then; none there leaves it selected
    private _point = [_heli, _side, _posX, _posY] call fza_mpd_fnc_cursorPoint;
    if (_point isEqualTo []) exitWith {};
    _state set ["caq", 0];
    private _seat = [_heli] call fza_fnc_getSeat;
    if (_point # 0 == POINT_TYPE_FCR) exitWith {
        private _entry = (_state getOrDefault ["cursorFcr", []]) select {(_x # 1) isEqualTo _point};
        if (_entry isNotEqualTo []) then {
            (_entry # 0) params ["_pos", "", "_target"];
            if (FCR_OWNER(_heli) == _seat) then {[_target, _pos] call _setNts};
            private _id = [POINT_TYPE_TG, POINT_INDEX_TG_FCR_CAQ];
            [_heli, _id, "TG", "FCR", [_pos # 0, _pos # 1, 0], getTerrainHeightASL _pos max 0] call fza_dms_fnc_pointCreate;
            [_heli, _id call fza_dms_fnc_pointToString] call fza_fnc_targetingAcqSet;
        };
    };
    [_heli, _point call fza_dms_fnc_pointToString] call fza_fnc_targetingAcqSet;
};

// ZN: a corner of the zone being drawn, or the TRP centre
if (_subPage == 6) exitWith {
    private _tsd = _persistState get _page;
    [_heli, _state, _tsd, [_posX, _posY] call _mapPos, ([_heli, _tsd] call fza_mpd_fnc_tsdFrame) # 1] call fza_mpd_fnc_tsdZNCursorEnter;
};

// WPT or THRT ADD: a point of the chosen type, at the cursor, at ground level
if (_subPage in [2, 4] && {_variant == 1}) exitWith {
    if (_kuState != KU_STATE_OFF) exitWith {};
    private _type = _state get "addType";
    private _id = [_heli, _type] call fza_dms_fnc_pointNextFree;
    private _ident = ["WP", "TU", "CP", "", "TG"] select _type;
    private _pos = [_posX, _posY] call _mapPos;
    if !([_heli, _id, _ident, _ident, _pos, getTerrainHeightASL _pos max 0] call fza_dms_fnc_pointCreate) exitWith {};
    _heli setVariable [["fza_mpd_tsdWptCurrentSel", "fza_mpd_tsdThrtCurrentSel"] select (_subPage == 4), _id];
    _state set ["subPageVarPage", [_subPage, 0]];
};

// A TSD point, chosen as if entered on the KU; DEL, EDT and RTE ADD go on to their pages for a chosen point, RTE DIR
// flies direct to it
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
        if (_variant in [4, 5]) then {
            // As the DIR page's POINT entry (fza_mpd_fnc_tsdRTEHandleControl)
            [_heli, _point, true] call fza_dms_fnc_routeSetDir;
            _heli setVariable ["fza_ah64_routeCurPoint", -1, true];
            _state set ["subPageVarPage", [3, 0]];
        } else {
            _heli setVariable ["fza_mpd_tsdRteCurrentSel", _point];
            _state set ["subPageVarPage", [3, 2]];
        };
    };
};
