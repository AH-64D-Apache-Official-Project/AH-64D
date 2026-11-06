/* ----------------------------------------------------------------------------
Function: fza_mplanner_fnc_dtcMap

Description:
    The DTC map: an Arma map laid over the planner browser's map area, which
    the browser can't draw over. The page tells it where its map area is, what
    to draw (fza_mplanner_fnc_dtcMapDraw) and hands it clicks; it hands the page
    each click's world position.

    Modes:
    "show", [x, y, w, h] - the map area, as fractions of the browser
    "hide"
    "click", [x, y] - a click, as fractions of the map area
    "refocus" - the map takes the mouse for panning and zooming
    "sync", json - {"d": [[points, closed, colour, label], ...], "p": [[position, label, ident], ...],
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

private _toPage = {
    params ["_x", "_y"];
    private _world = _map ctrlMapScreenToWorld [_x, _y];
    // How far from the click a point is taken as clicked: 0.015 of the screen
    private _reach = _world distance2D (_map ctrlMapScreenToWorld [_x + 0.015, _y]);
    private _code = format ["window.fzaDtc && window.fzaDtc.onMapClick(%1,%2,%3,'%4',%5);",
        (_world # 0) toFixed 1, (_world # 1) toFixed 1, (getTerrainHeightASL _world) toFixed 1, [_world] call fza_dms_fnc_posToGrid, _reach toFixed 1];
    [_browser, _code] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
};

switch (_mode) do {
    case "show": {
        params ["", ["_nx", 0, [0]], ["_ny", 0, [0]], ["_nw", 0, [0]], ["_nh", 0, [0]]];
        if (_nw <= 0 || {_nh <= 0}) exitWith {};
        (ctrlPosition _browser) params ["_bx", "_by", "_bw", "_bh"];
        private _pos = [_bx + _nx * _bw, _by + _ny * _bh, _nw * _bw, _nh * _bh];
        if (!ctrlShown _map || {(ctrlPosition _map) isNotEqualTo _pos}) then {
            _map ctrlSetPosition _pos;
            _map ctrlCommit 0;
            _map ctrlShow true;
        };
        if (isNil {_map getVariable "fza_mplanner_dtcDrawEh"}) then {
            _map setVariable ["fza_mplanner_dtcDrawEh", _map ctrlAddEventHandler ["Draw", {_this call fza_mplanner_fnc_dtcMapDraw}]];
            _map ctrlAddEventHandler ["MouseButtonUp", {
                params ["_ctrl", "_button", "_x", "_y"];
                if (_button != 0) exitWith {false};
                (ctrlPosition _ctrl) params ["_cx", "_cy", "_cw", "_ch"];
                ["click", (_x - _cx) / _cw, (_y - _cy) / _ch] call fza_mplanner_fnc_dtcMap;
                false
            }];
            private _heli = uiNamespace getVariable ["fza_mplanner_target", objNull];
            private _centre = [getPos _heli, [worldSize / 2, worldSize / 2, 0]] select (isNull _heli);
            _map ctrlMapAnimAdd [0, 0.15, _centre];
            ctrlMapAnimCommit _map;
        };
    };
    case "hide": {
        _map ctrlShow false;
    };
    case "click": {
        params ["", ["_nx", 0, [0]], ["_ny", 0, [0]]];
        // The map and the page can both report a click
        if (diag_tickTime - (uiNamespace getVariable ["fza_mplanner_dtcClickAt", -1]) < 0.15) exitWith {};
        uiNamespace setVariable ["fza_mplanner_dtcClickAt", diag_tickTime];
        (ctrlPosition _map) params ["_cx", "_cy", "_cw", "_ch"];
        [_cx + (_nx max 0 min 1) * _cw, _cy + (_ny max 0 min 1) * _ch] call _toPage;
        // The map keeps the mouse for panning and zooming
        if (focusedCtrl _display != _map) then {ctrlSetFocus _map};
    };
    case "refocus": {
        if (ctrlShown _map && {focusedCtrl _display != _map}) then {ctrlSetFocus _map};
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
