// The DTC map's lines, areas, zones and points (fza_mplanner_fnc_dtcMap "sync"), and the point or vertex being
// dragged at the mouse or the map panned by it
params ["_map"];

// The TSD's colours (fza_mpd_fnc_tsdZoneItems, fza_mpd_fnc_tsdSegments): lines green, areas red, PF zones white,
// NF zones yellow, routes green, FLET red, FLOT blue, FSCL white; an inactive zone is dashed, an active one alternates
// its dashes
private _colours = [[0, 1, 0, 1], [1, 0, 0.2, 1], [1, 1, 1, 1], [1, 1, 0, 1], [0, 1, 0, 1], [1, 0, 0, 1], [0.4, 0.6, 1, 1], [1, 1, 1, 1]];
// The selected item's highlight, behind the shape or point, a pale yellow apart from the NF zones' and hazards' yellow
#define SELECTED_COLOUR [1, 0.9, 0.5, 1]
// Everything drawn, at twice the TSD's size
#define SCALE 2
private _w0 = _map ctrlMapScreenToWorld [0, 0];
private _halfWidth = (_w0 distance2D (_map ctrlMapScreenToWorld [0.004 * SCALE, 0])) / 2;
if (_halfWidth <= 0) exitWith {};
// The dash and gap of each style in world metres, from their screen lengths: short dashes with equal gaps (1), and the
// active zone's alternation between those and long dashes twice a second (2)
private _dashLong = _w0 distance2D (_map ctrlMapScreenToWorld [0.01 * SCALE, 0]);
private _dashShort = [_dashLong / 3, _dashLong / 3];
private _dashes = [[], _dashShort, [_dashShort, [_dashLong, _dashLong * 0.6]] select (floor (diag_tickTime * 2) mod 2)];
// The dashes drawn this frame; past them the shapes are drawn solid
private _budget = 1500;

// The world the map shows, a little wider: only what is in it is drawn or dashed
(ctrlPosition _map) params ["_cx", "_cy", "_cw", "_ch"];
private _corner0 = _map ctrlMapScreenToWorld [_cx, _cy];
private _corner1 = _map ctrlMapScreenToWorld [_cx + _cw, _cy + _ch];
private _margin = _halfWidth * 4;
private _view = [
    ((_corner0 # 0) min (_corner1 # 0)) - _margin, ((_corner0 # 1) min (_corner1 # 1)) - _margin,
    ((_corner0 # 0) max (_corner1 # 0)) + _margin, ((_corner0 # 1) max (_corner1 # 1)) + _margin
];

// A segment's part in the view, as [from, to] fractions of it, else []
private _inView = {
    params ["_a", "_dx", "_dy"];
    _view params ["_x0", "_y0", "_x1", "_y1"];
    private _t0 = 0;
    private _t1 = 1;
    {
        _x params ["_p", "_q"];
        if (_p == 0) then {
            if (_q < 0) then {_t0 = 2};
        } else {
            private _k = _q / _p;
            if (_p < 0) then {_t0 = _t0 max _k} else {_t1 = _t1 min _k};
        };
    } forEach [[-_dx, (_a # 0) - _x0], [_dx, _x1 - (_a # 0)], [-_dy, (_a # 1) - _y0], [_dy, _y1 - (_a # 1)]];
    [[], [_t0, _t1]] select (_t1 > _t0)
};
// A shape solid (style 0), dashed (1) or alternating (2), at the given half width; the dash pattern runs on along it
private _shape = {
    params ["_pts", "_closed", "_colour", ["_style", 0], ["_hw", _halfWidth]];
    private _n = count _pts;
    if (_n < 2) exitWith {};
    private _tex = format (["#(rgb,8,8,3)color(%1,%2,%3,%4)"] + _colour);
    (_dashes param [_style, []]) params [["_on", 0], ["_off", 0]];
    private _period = _on + _off;
    private _along = 0;
    for "_i" from 1 to ([_n - 1, _n] select (_closed && {_n > 2})) do {
        private _a = _pts # (_i - 1);
        private _b = _pts # (_i mod _n);
        private _dx = (_b # 0) - (_a # 0);
        private _dy = (_b # 1) - (_a # 1);
        private _length = sqrt (_dx * _dx + _dy * _dy);
        if (_length <= 0) then {continue};
        private _part = [_a, _dx, _dy] call _inView;
        private _start = _along;
        _along = _along + _length;
        if (_part isEqualTo []) then {continue};
        private _from = (_part # 0) * _length;
        private _to = (_part # 1) * _length;
        private _ux = _dx / _length;
        private _uy = _dy / _length;
        private _dir = _a getDir _b;
        if (_period <= 0 || {_on <= 0} || {(_to - _from) / _period > _budget}) then {
            private _mid = (_from + _to) / 2;
            _map drawRectangle [[(_a # 0) + _ux * _mid, (_a # 1) + _uy * _mid], _hw, (_to - _from) / 2, _dir, _colour, _tex];
            continue;
        };
        // The dash under the view's edge, as the pattern runs from the shape's start
        private _at = _from - ((_start + _from) mod _period);
        while {_at < _to} do {
            private _s = _at max _from;
            private _e = (_at + _on) min _to;
            if (_e > _s) then {
                private _mid = (_s + _e) / 2;
                _map drawRectangle [[(_a # 0) + _ux * _mid, (_a # 1) + _uy * _mid], _hw, (_e - _s) / 2, _dir, _colour, _tex];
                _budget = _budget - 1;
            };
            _at = _at + _period;
        };
    };
};

getMousePosition params ["_mx", "_my"];
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

// The shapes, each vertex with a handle to drag it by, and a line short of four points with a smaller one at the
// middle of each segment to drag a new vertex out of; the selected shape drawn over a wide solid stroke of the
// highlight colour, itself as always
{
    _x params [["_pts", []], ["_closed", false], ["_colourIndex", 0], ["_label", ""], ["_atEnds", false], ["_key", ""], ["_style", 0], ["_middles", false], ["_selected", false]];
    if (count _pts < 2) then {continue};
    private _colour = _colours param [_colourIndex, _colours # 0];
    if (_key != "" && {_dragged select [0, count _key + 1] == _key + ":"}) then {
        _pts = +_pts;
        _pts set [parseNumber (_dragged select [count _key + 1]), _mouse];
    };
    if (_selected) then {[_pts, _closed, SELECTED_COLOUR, 0, _halfWidth * 3] call _shape};
    [_pts, _closed, _colour, _style] call _shape;
    // The handles stand out against the shape: black on a light one (white, yellow), white on the rest
    private _handleColour = [[1, 1, 1, 1], [0, 0, 0, 1]] select ((_colour # 0) + (_colour # 1) + (_colour # 2) >= 2);
    if (_key != "") then {
        {_map drawIcon ["\A3\ui_f\data\map\markers\military\dot_CA.paa", _handleColour, [_x # 0, _x # 1], 10 * SCALE, 10 * SCALE, 0]} forEach _pts;
    };
    if (_middles && {_dragged == ""}) then {
        for "_i" from 0 to count _pts - 2 do {
            _map drawIcon ["\A3\ui_f\data\map\markers\military\circle_CA.paa", _handleColour, [((_pts # _i # 0) + (_pts # (_i + 1) # 0)) / 2, ((_pts # _i # 1) + (_pts # (_i + 1) # 1)) / 2], 8 * SCALE, 8 * SCALE, 0];
        };
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

// The current route, then the points as the TSD draws them (fza_mpd_fnc_uiDrawPoint): the ident's
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
    _x params [["_pos", []], ["_label", ""], ["_ident", ""], ["_free", ""], ["_selected", false]];
    if (count _pos < 2) then {continue};
    private _details = [_ident] call fza_dms_fnc_pointGetIdentDetails;
    if (isNil "_details") then {_details = []};
    _details params [["_tex", ""], ["_tex2", ""], "", ["_colour", [0, 0, 0, 1]], ["_textA", []], ["_textB", []]];
    if (_colour isEqualTo []) then {_colour = [0, 0, 0, 1]};
    private _at = [[_pos # 0, _pos # 1], _mouse] select (_label == _dragged);
    // The selected point ringed
    if (_selected) then {_map drawIcon ["\A3\ui_f\data\map\markers\military\circle_CA.paa", SELECTED_COLOUR, _at, ICON_PX * 0.5, ICON_PX * 0.5, 0]};
    if (_tex != "") then {_map drawIcon [_tex, _colour, _at, ICON_PX, ICON_PX, 0]};
    if (_tex2 != "") then {_map drawIcon [_tex2, _colour, _at, ICON_PX, ICON_PX, 0]};
    private _number = _label select [1];
    if (_textA isNotEqualTo []) then {[_at, _colour, _textA, _number, _free] call _text};
    if (_textB isNotEqualTo []) then {[_at, _colour, _textB, _number, _free] call _text};
} forEach (uiNamespace getVariable ["fza_mplanner_dtcPoints", []]);
