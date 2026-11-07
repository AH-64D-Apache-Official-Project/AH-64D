/* ----------------------------------------------------------------------------
Function: fza_mplanner_fnc_dtcMap

Description:
    The DTC map: an Arma map laid over the planner browser's map area, which
    the browser can't draw over. The page tells it where its map area is, what
    to draw (fza_mplanner_fnc_dtcMapDraw) and hands it the mouse; it hands the
    page each press's world position: a click, a point dragged to a new place,
    a point's list row dropped, a point right-clicked for its ident menu.

    The map never has the focus, so its own mouse handling (a right drag pans)
    never runs: the page keeps the mouse and reports it. A left drag on a
    point moves it, on the map pans it (fza_mplanner_fnc_dtcMapDraw, each
    frame from the mouse), the wheel zooms about the mouse, the right button
    is the menu's.

    Modes:
    "show", [x, y, w, h] - the map area, as fractions of the browser
    "hide"
    "down", [x, y] - a left press, as fractions of the map area: a point or a shape's vertex to drag, else a pan
    "up", [x, y] - its release: the dragged point or vertex moved there, the pan over, else a click
    "zoom", [x, y, in] - a wheel notch there
    "nudge", [east, north] - W A S D: the view moved by those fractions of its width and height
    "drop", [x, y, kind, slot] - a point's list row dropped there
    "menu", [x, y] - a right click: the page's ident menu for the point there, else its drawing menu for that spot
    "terrain", json - [[x, y], ...]: the ground height under each, back to the page in that order
    "sync", json - {"d": [[points, closed, colour, label, label at the ends, kind:slot], ...], "p": [[position, label, ident, free text], ...],
                    "r": route points, "t": draft or 0}

Parameters:
    _mode, then the mode's arguments

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
disableSerialization;
params [["_mode", "", [""]]];

private _display = uiNamespace getVariable ["fza_mplanner_display", displayNull];
if (isNull _display) exitWith {};
private _map = _display displayCtrl 101;
private _browser = _display displayCtrl 100;
if (isNull _map) exitWith {};

private _js = {
    params ["_code"];
    [_browser, _code] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
};
// A map-area fraction as a screen position
private _screen = {
    params ["_nx", "_ny"];
    (ctrlPosition _map) params ["_cx", "_cy", "_cw", "_ch"];
    [_cx + (_nx max 0 min 1) * _cw, _cy + (_ny max 0 min 1) * _ch]
};
// Where a map animation puts its position on the screen, and its scale per ctrlMapScale, as measured
// (fza_mplanner_fnc_dtcMapDraw); the control's centre and 1 until then
private _anchor = uiNamespace getVariable ["fza_mplanner_dtcAnchor", []];
private _centre = {
    private _at = if (_anchor isNotEqualTo []) then {_anchor # 0} else {
        (ctrlPosition _map) params ["_cx", "_cy", "_cw", "_ch"];
        [_cx + _cw / 2, _cy + _ch / 2]
    };
    _map ctrlMapScreenToWorld _at
};
private _zoom = {(ctrlMapScale _map) * (_anchor param [1, 1])};
// A screen position as the page takes it: world x, y, z and grid, as JS arguments
private _worldArgs = {
    params ["_sx", "_sy"];
    private _world = _map ctrlMapScreenToWorld [_sx, _sy];
    format ["%1,%2,%3,'%4'", (_world # 0) toFixed 1, (_world # 1) toFixed 1, (getTerrainHeightASL _world) toFixed 1, [_world] call fza_dms_fnc_posToGrid]
};
// How far from a press a point is taken as pressed: 0.015 of the screen
private _reach = {
    params ["_sx", "_sy"];
    (_map ctrlMapScreenToWorld [_sx, _sy]) distance2D (_map ctrlMapScreenToWorld [_sx + 0.015, _sy])
};
// The point nearest a screen position, within reach: [label, ident], else []; when asked, a line's, area's or zone's
// vertex as well: [kind:slot:index, ""]
private _pointAt = {
    params ["_sx", "_sy", ["_vertices", false]];
    private _world = _map ctrlMapScreenToWorld [_sx, _sy];
    private _best = [];
    private _bestD = [_sx, _sy] call _reach;
    {
        _x params [["_pos", []], ["_label", ""], ["_ident", ""]];
        if (count _pos < 2) then {continue};
        private _d = _world distance2D [_pos # 0, _pos # 1];
        if (_d <= _bestD) then {_bestD = _d; _best = [_label, _ident]};
    } forEach (uiNamespace getVariable ["fza_mplanner_dtcPoints", []]);
    if (_vertices) then {
        {
            _x params [["_pts", []], "", "", "", "", ["_key", ""]];
            if (_key == "") then {continue};
            {
                private _d = _world distance2D [_x # 0, _x # 1];
                if (_d <= _bestD) then {_bestD = _d; _best = [_key + ":" + str _forEachIndex, ""]};
            } forEach _pts;
        } forEach (uiNamespace getVariable ["fza_mplanner_dtcDraw", []]);
    };
    _best
};

switch (_mode) do {
    case "show": {
        params ["", ["_nx", 0, [0]], ["_ny", 0, [0]], ["_nw", 0, [0]], ["_nh", 0, [0]]];
        if (_nw <= 0 || {_nh <= 0}) exitWith {};
        (ctrlPosition _browser) params ["_bx", "_by", "_bw", "_bh"];
        private _pos = [_bx + _nx * _bw, _by + _ny * _bh, _nw * _bw, _nh * _bh];
        if (!ctrlShown _map || {(ctrlPosition _map) isNotEqualTo _pos}) then {
            // The view kept across the move; the first time, the aircraft. The moved map is measured again
            private _home = [call _centre, call _zoom];
            if (isNil {_map getVariable "fza_mplanner_dtcDrawEh"}) then {
                _map setVariable ["fza_mplanner_dtcDrawEh", _map ctrlAddEventHandler ["Draw", {_this call fza_mplanner_fnc_dtcMapDraw}]];
                private _heli = uiNamespace getVariable ["fza_mplanner_target", objNull];
                _home = [[getPos _heli, [worldSize / 2, worldSize / 2, 0]] select (isNull _heli), 0.15];
            };
            _map ctrlSetPosition _pos;
            _map ctrlCommit 0;
            _map ctrlShow true;
            uiNamespace setVariable ["fza_mplanner_dtcAnchor", nil];
            uiNamespace setVariable ["fza_mplanner_dtcHome", _home + [diag_frameNo]];
            _map ctrlMapAnimAdd [0, _home # 1, _home # 0];
            ctrlMapAnimCommit _map;
        };
        // Under the browser, through the page's clear map area; the browser keeps the mouse
        if (focusedCtrl _display == _map) then {ctrlSetFocus _browser};
    };
    case "hide": {
        _map ctrlShow false;
        uiNamespace setVariable ["fza_mplanner_dtcDrag", []];
    };
    case "down": {
        params ["", ["_nx", 0, [0]], ["_ny", 0, [0]]];
        private _at = [_nx, _ny] call _screen;
        private _hit = (_at + [true]) call _pointAt;
        // [label, ident, screen position pressed at, map centre then]; no label is a pan
        if (_hit isEqualTo []) then {_hit = ["", ""]};
        uiNamespace setVariable ["fza_mplanner_dtcDrag", _hit + [_at, call _centre]];
    };
    case "up": {
        params ["", ["_nx", 0, [0]], ["_ny", 0, [0]]];
        private _at = [_nx, _ny] call _screen;
        private _drag = uiNamespace getVariable ["fza_mplanner_dtcDrag", []];
        uiNamespace setVariable ["fza_mplanner_dtcDrag", []];
        // A press that didn't move is a click; one that did moved its point or vertex, or panned
        private _moved = _drag isNotEqualTo [] && {(_drag # 2) distance2D _at > 0.004};
        if (!_moved) exitWith {
            [format ["window.fzaDtc && window.fzaDtc.onMapClick(%1,%2);", _at call _worldArgs, (_at call _reach) toFixed 1]] call _js;
        };
        private _label = _drag # 0;
        if (_label == "") exitWith {};
        if (":" in _label) then {
            (_label splitString ":") params ["_kind", "_slot", "_index"];
            [format ["window.fzaDtc && window.fzaDtc.onVertexMoved('%1',%2,%3,%4);", _kind, _slot, _index, _at call _worldArgs]] call _js;
        } else {
            [format ["window.fzaDtc && window.fzaDtc.onPointMoved('%1',%2);", _label, _at call _worldArgs]] call _js;
        };
    };
    case "zoom": {
        params ["", ["_nx", 0, [0]], ["_ny", 0, [0]], ["_in", true, [true]]];
        private _at = [_nx, _ny] call _screen;
        private _old = call _zoom;
        // A smaller scale is closer in
        private _new = (_old * ([1.2, 1 / 1.2] select _in)) max 0.001 min 1;
        // The world under the mouse stays there: the centre's offset from it scales with the map
        private _under = _map ctrlMapScreenToWorld _at;
        (call _centre) params ["_cx", "_cy"];
        private _k = _new / _old;
        _map ctrlMapAnimAdd [0, _new, [(_under # 0) - ((_under # 0) - _cx) * _k, (_under # 1) - ((_under # 1) - _cy) * _k]];
        ctrlMapAnimCommit _map;
    };
    case "nudge": {
        params ["", ["_east", 0, [0]], ["_north", 0, [0]]];
        // By those fractions of the view's width eastward and height northward
        (ctrlPosition _map) params ["", "", "_cw", "_ch"];
        private _w0 = _map ctrlMapScreenToWorld [0, 0];
        private _perX = abs ((((_map ctrlMapScreenToWorld [0.1, 0]) # 0) - (_w0 # 0)) / 0.1);
        private _perY = abs ((((_map ctrlMapScreenToWorld [0, 0.1]) # 1) - (_w0 # 1)) / 0.1);
        (call _centre) params ["_cx", "_cy"];
        _map ctrlMapAnimAdd [0, call _zoom, [_cx + _east * _cw * _perX, _cy + _north * _ch * _perY]];
        ctrlMapAnimCommit _map;
    };
    case "drop": {
        params ["", ["_nx", 0, [0]], ["_ny", 0, [0]], ["_kind", "", [""]], ["_slot", 0, [0]]];
        private _at = [_nx, _ny] call _screen;
        [format ["window.fzaDtc && window.fzaDtc.onMapDrop(%1,'%2',%3);", _at call _worldArgs, _kind, _slot]] call _js;
    };
    case "menu": {
        params ["", ["_nx", 0, [0]], ["_ny", 0, [0]]];
        private _at = [_nx, _ny] call _screen;
        private _hit = _at call _pointAt;
        (ctrlPosition _browser) params ["_bx", "_by", "_bw", "_bh"];
        private _page = format ["%1,%2", ((_at # 0) - _bx) / _bw, ((_at # 1) - _by) / _bh];
        // A point's ident menu, else the drawing menu for that spot
        if (_hit isNotEqualTo []) then {
            [format ["window.fzaDtc && window.fzaDtc.onPointMenu('%1',%2);", _hit # 0, _page]] call _js;
        } else {
            [format ["window.fzaDtc && window.fzaDtc.onMapMenu(%1,%2);", _page, _at call _worldArgs]] call _js;
        };
    };
    case "terrain": {
        params ["", ["_json", "", [""]]];
        private _at = fromJSON _json;
        if !(_at isEqualType []) exitWith {};
        private _heights = _at apply {round ((getTerrainHeightASL [_x # 0, _x # 1]) * 10) / 10};
        [format ["window.fzaDtc && window.fzaDtc.onTerrain(%1);", toJSON _heights]] call _js;
    };
    case "sync": {
        params ["", ["_json", "", [""]]];
        private _data = fromJSON _json;
        if !(_data isEqualType createHashMap) exitWith {};
        uiNamespace setVariable ["fza_mplanner_dtcDraw", _data getOrDefault ["d", []]];
        uiNamespace setVariable ["fza_mplanner_dtcDraft", _data getOrDefault ["t", 0]];
        uiNamespace setVariable ["fza_mplanner_dtcPoints", _data getOrDefault ["p", []]];
        uiNamespace setVariable ["fza_mplanner_dtcRoute", _data getOrDefault ["r", []]];
    };
};
