// The DTC map's lines, areas, zones and points (fza_mplanner_fnc_dtcMap "sync"), the point or vertex being dragged
// at the mouse or the map panned by it, and the shape being drawn out to the mouse
params ["_map"];

// Lines green, areas olive, PF zones black, NF zones orange, routes purple, FLET red, FLOT blue, FSCL white
private _colours = [[0, 0.5, 0, 1], [0.4, 0.4, 0, 1], [0.15, 0.15, 0.15, 1], [0.95, 0.55, 0, 1], [0.6, 0, 0.7, 1], [0.85, 0, 0, 1], [0, 0.3, 0.9, 1], [1, 1, 1, 1]];
// Everything drawn, at twice the TSD's size
#define SCALE 2
private _w0 = _map ctrlMapScreenToWorld [0, 0];
private _halfWidth = (_w0 distance2D (_map ctrlMapScreenToWorld [0.004 * SCALE, 0])) / 2;
if (_halfWidth <= 0) exitWith {};

private _segment = {
    params ["_a", "_b", "_colour"];
    private _length = _a distance2D _b;
    if (_length <= 0) exitWith {};
    private _mid = [((_a # 0) + (_b # 0)) / 2, ((_a # 1) + (_b # 1)) / 2];
    _map drawRectangle [_mid, _halfWidth, _length / 2, _a getDir _b, _colour, format (["#(rgb,8,8,3)color(%1,%2,%3,%4)"] + _colour)];
};
private _shape = {
    params ["_pts", "_closed", "_colour"];
    private _pts2 = _pts apply {[_x # 0, _x # 1]};
    for "_i" from 1 to count _pts2 - 1 do {[_pts2 # (_i - 1), _pts2 # _i, _colour] call _segment};
    if (_closed && {count _pts2 > 2}) then {[_pts2 # (count _pts2 - 1), _pts2 # 0, _colour] call _segment};
};

getMousePosition params ["_mx", "_my"];
(ctrlPosition _map) params ["_cx", "_cy", "_cw", "_ch"];
private _mouse = [];
if (_mx > _cx && {_mx < _cx + _cw} && {_my > _cy} && {_my < _cy + _ch}) then {
    private _w = _map ctrlMapScreenToWorld [_mx, _my];
    _mouse = [_w # 0, _w # 1];
};
// Where a map animation puts its position on the screen, and its scale per ctrlMapScale: measured from the one
// fza_mplanner_fnc_dtcMap "show" commits, a few frames on, for its pan, zoom and nudge
(uiNamespace getVariable ["fza_mplanner_dtcHome", []]) params [["_home", []], ["_homeZoom", 0.15], ["_homeFrame", 0]];
if (isNil {uiNamespace getVariable "fza_mplanner_dtcAnchor"} && {_home isNotEqualTo []} && {diag_frameNo > _homeFrame + 2} && {ctrlMapAnimDone _map}) then {
    uiNamespace setVariable ["fza_mplanner_dtcAnchor", [_map ctrlMapWorldToScreen _home, _homeZoom / (ctrlMapScale _map)]];
};

// A left drag once it has moved: a point or a shape's vertex (kind:slot:index) goes with the mouse; with neither, the
// map does, the spot pressed on staying under the mouse (the anchor's world position when pressed, less the mouse's
// travel in world metres)
private _drag = uiNamespace getVariable ["fza_mplanner_dtcDrag", []];
private _dragged = "";
if (_drag isNotEqualTo [] && {[_mx, _my] distance2D (_drag # 2) > 0.004}) then {
    _dragged = _drag # 0;
    if (_dragged == "") then {
        private _perX = (((_map ctrlMapScreenToWorld [0.1, 0]) # 0) - (_w0 # 0)) / 0.1;
        private _perY = (((_map ctrlMapScreenToWorld [0, 0.1]) # 1) - (_w0 # 1)) / 0.1;
        (_drag # 2) params ["_sx", "_sy"];
        (_drag # 3) params ["_c0x", "_c0y"];
        private _zoom = (ctrlMapScale _map) * ((uiNamespace getVariable ["fza_mplanner_dtcAnchor", []]) param [1, 1]);
        ctrlMapAnimClear _map;
        _map ctrlMapAnimAdd [0, _zoom, [_c0x - (_mx - _sx) * _perX, _c0y - (_my - _sy) * _perY]];
        ctrlMapAnimCommit _map;
    };
};
if (_mouse isEqualTo []) then {_dragged = ""};

// The shapes, each vertex with a handle to drag it by
{
    _x params [["_pts", []], ["_closed", false], ["_colourIndex", 0], ["_label", ""], ["_atEnds", false], ["_key", ""]];
    if (count _pts < 2) then {continue};
    private _colour = _colours param [_colourIndex, _colours # 0];
    if (_key != "" && {_dragged select [0, count _key + 1] == _key + ":"}) then {
        _pts = +_pts;
        _pts set [parseNumber (_dragged select [count _key + 1]), _mouse];
    };
    [_pts, _closed, _colour] call _shape;
    if (_key != "") then {
        {_map drawIcon ["\A3\ui_f\data\map\markers\military\dot_CA.paa", _colour, [_x # 0, _x # 1], 10 * SCALE, 10 * SCALE, 0]} forEach _pts;
    };
    if (_label == "") then {continue};
    if (_atEnds) then {
        // As the TSD labels a phase line: ending at the western end and running west, starting at the eastern end and
        // running east
        private _ends = [_pts # 0, _pts # (count _pts - 1)];
        if (_ends # 0 # 0 > _ends # 1 # 0) then {reverse _ends};
        _map drawIcon ["#(argb,8,8,3)color(0,0,0,0)", _colour, [_ends # 0 # 0, _ends # 0 # 1], 0, 0, 0, _label, 2, 0.045 * SCALE, "PuristaBold", "left"];
        _map drawIcon ["#(argb,8,8,3)color(0,0,0,0)", _colour, [_ends # 1 # 0, _ends # 1 # 1], 0, 0, 0, _label, 2, 0.045 * SCALE, "PuristaBold", "right"];
    } else {
        private _sum = [0, 0];
        {_sum = [(_sum # 0) + (_x # 0), (_sum # 1) + (_x # 1)]} forEach _pts;
        _map drawIcon ["#(argb,8,8,3)color(0,0,0,0)", _colour, [(_sum # 0) / count _pts, (_sum # 1) / count _pts], 0, 0, 0, _label, 2, 0.045 * SCALE, "PuristaBold", "center"];
    };
} forEach (uiNamespace getVariable ["fza_mplanner_dtcDraw", []]);

// The route chosen on the Routes tab, then the points as the TSD draws them (fza_mpd_fnc_uiDrawPoint): the ident's
// textures, and its two texts at their offsets across the icon, the number, the free text or the ident's own letters
private _route = (uiNamespace getVariable ["fza_mplanner_dtcRoute", []]) apply {[_x # 0, _x # 1]};
if (count _route > 1) then {[_route, false, _colours # 4] call _shape};
#define ICON_PX (26 * SCALE)
#define TEXT_SIZE (0.02 * SCALE)
// The icon's width and height in world metres (its height southward, as the screen runs), and the TSD's text height as
// a fraction of the icon
private _iconW = ((((_map ctrlMapScreenToWorld [ICON_PX * pixelW, 0]) # 0) - (_w0 # 0)));
private _iconH = ((((_map ctrlMapScreenToWorld [0, ICON_PX * pixelH]) # 1) - (_w0 # 1)));
private _textH = 0.00208 / 0.09;
private _text = {
    params ["_at", "_colour", "_data", "_number", "_free"];
    _data params ["_text", "_offset", "_xAlign", "_yAlign"];
    if (_text isEqualTo 0) then {_text = _number};
    if (_text isEqualTo 1) then {_text = _free};
    if (_text isEqualTo "") exitWith {};
    // The text's centre; drawn starting at it, ending at it, or centred below it, so that one is raised by half
    private _ay = (_at # 1) + ((_offset # 1) - 0.5) * _iconH;
    switch (_yAlign) do {
        case "top": {_ay = _ay + 0.5 * _textH * _iconH};
        case "bottom": {_ay = _ay - 0.5 * _textH * _iconH};
    };
    private _align = switch (_xAlign) do {
        case "right": {"left"};
        case "center": {_ay = _ay - 0.5 * _textH * _iconH; "center"};
        default {"right"};
    };
    _map drawIcon ["#(argb,8,8,3)color(0,0,0,0)", _colour, [(_at # 0) + ((_offset # 0) - 0.5) * _iconW, _ay], 0, 0, 0, _text, 2, TEXT_SIZE, "fza_BMKApacheFont", _align];
};
{
    _x params [["_pos", []], ["_label", ""], ["_ident", ""], ["_free", ""]];
    if (count _pos < 2) then {continue};
    private _details = [_ident] call fza_dms_fnc_pointGetIdentDetails;
    if (isNil "_details") then {_details = []};
    _details params [["_tex", ""], ["_tex2", ""], "", ["_colour", [0, 0, 0, 1]], ["_textA", []], ["_textB", []]];
    if (_colour isEqualTo []) then {_colour = [0, 0, 0, 1]};
    private _at = [[_pos # 0, _pos # 1], _mouse] select (_label == _dragged);
    if (_tex != "") then {_map drawIcon [_tex, _colour, _at, ICON_PX, ICON_PX, 0]};
    if (_tex2 != "") then {_map drawIcon [_tex2, _colour, _at, ICON_PX, ICON_PX, 0]};
    private _number = _label select [1];
    if (_textA isNotEqualTo []) then {[_at, _colour, _textA, _number, _free] call _text};
    if (_textB isNotEqualTo []) then {[_at, _colour, _textB, _number, _free] call _text};
} forEach (uiNamespace getVariable ["fza_mplanner_dtcPoints", []]);

// The shape being drawn: its points so far, out to the mouse; a box from its corner
private _draft = uiNamespace getVariable ["fza_mplanner_dtcDraft", 0];
if !(_draft isEqualType createHashMap) exitWith {};
private _verts = (_draft getOrDefault ["pts", []]) apply {[_x # 0, _x # 1]};
private _colour = _colours param [_draft getOrDefault ["c", 0], _colours # 0];
private _box = _draft getOrDefault ["box", false];
{_map drawIcon ["\A3\ui_f\data\map\markers\military\dot_CA.paa", _colour, _x, 12 * SCALE, 12 * SCALE, 0]} forEach _verts;
if (_mouse isEqualTo []) exitWith {
    if (count _verts > 1) then {[_verts, false, _colour] call _shape};
};
if (_box && {count _verts == 1}) exitWith {
    (_verts # 0) params ["_ax", "_ay"];
    _mouse params ["_bx", "_by"];
    [[[_ax, _ay], [_ax, _by], [_bx, _by], [_bx, _ay]], true, _colour] call _shape;
};
if (_verts isNotEqualTo []) then {
    [_verts + [_mouse], (count _verts > 1) && {_draft getOrDefault ["closed", false]}, _colour] call _shape;
};
