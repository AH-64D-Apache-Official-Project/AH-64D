/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_tsdHtmlDraw

Description:
    Sends the HTML TSD (ui\tsd\tsd.js) what the native TSD draws as controls and
    canvas lines, as three payloads, each sent only when it changes:
    - defs:  every point ident seen so far, its textures, size, colour and text places
    - world: the points and lines that stay put in the world (DMS points, zone labels,
             shot-at, obstacles, FCR targets, the route, the zones)
    - frame: the map's frame, the chosen point and the cursor, and what moves with the
             aircraft (the points from _dynStart on, the TADS line, the FCR footprint,
             the zone being drawn)

Parameters:
    _heli         - The helicopter
    _mpdIndex     - 0 left MPD, 1 right MPD
    _state        - The TSD's state
    _persistState - The TSD's persistent state
    _points       - The TSD's points, as fza_mpd_fnc_drawIcons takes them
    _dynStart     - The first of _points that moves with the aircraft
    _highlight    - The point ID [type, ID] the MPD cursor is on, or []

Returns:
    Nothing

Examples:
    --- Code
    [_heli, _mpdIndex, _state, _persistState, _points, _dynStart, _highlight] call fza_mpd_fnc_tsdHtmlDraw
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\tsd.hpp"
disableSerialization;
params ["_heli", "_mpdIndex", "_state", "_persistState", ["_points", []], ["_dynStart", 0], ["_highlight", []]];

private _ctrl = [_heli, _mpdIndex] call fza_mpd_fnc_htmlCtrl;
if (isNull _ctrl) exitWith {};

// The MPD's video underlay under the map
[_heli, _mpdIndex, ctrlParent _ctrl] call fza_mpd_fnc_videoApply;

// The route menu has no map
if ((_state get "subPageVarPage") isEqualTo TSD_RTE_RTM) exitWith {
    [_ctrl, "fzaTSD.world", '{"pts":[],"segs":[],"polys":[]}', "w"] call fza_mpd_fnc_htmlPush;
    [_ctrl, "fzaTSD.frame", '{"f":null}', "f"] call fza_mpd_fnc_htmlPush;
};

private _tsdScale = [_persistState] call fza_mpd_fnc_tsdScale;
private _ctr      = [0.5, 0.75 - 0.25 * (_persistState get "ctr")];
([_heli, _persistState] call fza_mpd_fnc_tsdFrame) params ["_framePos", "_frameHeading"];

// Ident definitions, kept on the control: [texture key, texture 2 key, size, colour, text A place, text B place,
// text A, text B]; a place is [x offset, y offset, horizontal, vertical], 0 without text; [] for an unknown ident
private _defs = _ctrl getVariable "fza_mpd_tsdDefs";
if (isNil "_defs") then {
    _defs = createHashMap;
    _ctrl setVariable ["fza_mpd_tsdDefs", _defs];
};
private _defsGrew = false;

// A texture's key in the page's icon atlas: its file name without _ca, lower case
private _texKey = {
    if !(_this isEqualType "") exitWith {""};
    private _parts = (toLower _this) splitString "\/";
    if (_parts isEqualTo []) exitWith {""};
    private _name = _parts # (count _parts - 1);
    if (count _name > 4 && {_name select [count _name - 4, 4] == ".paa"}) then {_name = _name select [0, count _name - 4]};
    if (count _name > 3 && {_name select [count _name - 3, 3] == "_ca"}) then {_name = _name select [0, count _name - 3]};
    _name
};
private _place = {
    params ["_text"];
    _text params [["_tpl", ""], ["_offset", [0, 0]], ["_hAlign", "center"], ["_vAlign", "center"]];
    if (_tpl isEqualTo "") exitWith {0};
    [_offset param [0, 0], _offset param [1, 0], _hAlign, _vAlign]
};
// A position the page can take: two finite numbers. toJSON writes a NaN or an infinity as text JSON cannot parse,
// which would lose the whole payload
private _isXY = {
    _this isEqualType [] && {count _this >= 2} && {(_this # 0) isEqualType 0} && {(_this # 1) isEqualType 0}
        && {finite (_this # 0)} && {finite (_this # 1)}
};
private _defOf = {
    params ["_ident"];
    private _def = _defs get _ident;
    if (!isNil "_def") exitWith {_def};
    private _details = [_ident] call fza_dms_fnc_pointGetIdentDetails;
    _def = [];
    if (!isNil "_details" && {_details isEqualType []} && {count _details >= 6}) then {
        _details params [["_tex", ""], ["_tex2", ""], ["_size", 0], ["_color", [1, 1, 1, 1]], ["_textA", []], ["_textB", []]];
        // An icon of no size or a colour that isn't four numbers is not drawn, as fza_mpd_fnc_uiDrawPoint
        if (_size isEqualType 0 && {finite _size} && {_size > 0} && {_color isEqualTypeArray [0, 0, 0, 0]}) then {
            _def = [_tex call _texKey, _tex2 call _texKey, _size, _color, [_textA] call _place, [_textB] call _place, _textA param [0, ""], _textB param [0, ""]];
        };
    };
    _defs set [_ident, _def];
    _defsGrew = true;
    _def
};

// A point for the page: [ident, 1 world or 0 screen, x, y, text A, text B, ID type, ID number]
private _entry = {
    params ["_pt"];
    _pt params [["_mode", true], ["_pos", []], "", ["_type", -1], ["_id", -1], ["_ident", ""]];
    if (!(_ident isEqualType "") || {!(_pos call _isXY)}) exitWith {nil};
    private _def = [_ident] call _defOf;
    if (_def isEqualTo []) exitWith {nil};
    private _textA = "";
    private _textB = "";
    if ((_def # 4) isNotEqualTo 0) then {_textA = [[_pt, _def # 6] call fza_dms_fnc_pointFillIconText] param [0, ""]};
    if ((_def # 5) isNotEqualTo 0) then {_textB = [[_pt, _def # 7] call fza_dms_fnc_pointFillIconText] param [0, ""]};
    if !(_textA isEqualType "") then {_textA = str _textA};
    if !(_textB isEqualType "") then {_textB = str _textB};
    private _idType = _type;
    private _idNum  = _id;
    if (_id isEqualType []) then {
        _idType = _id param [0, -1];
        _idNum  = _id param [1, -1];
    };
    [_ident, [0, 1] select (_mode isEqualTo true || {_mode isEqualTo 1}), _pos # 0, _pos # 1, _textA, _textB, _idType, _idNum]
};
private _entries = {
    params ["_from", "_to"];
    private _out = [];
    for "_i" from _from to (_to - 1) do {
        private _e = [_points # _i] call _entry;
        if (!isNil "_e") then {_out pushBack _e};
    };
    _out
};
// [x1, y1, x2, y2, colour], the lines with both ends drawable
private _segs = {
    params ["_list"];
    (_list select {(_x # 0) call _isXY && {(_x # 1) call _isXY}}) apply {[_x # 0 # 0, _x # 0 # 1, _x # 1 # 0, _x # 1 # 1, _x # 2]}
};
// [x1, y1, x2, y2, ...], leaving out what cannot be drawn
private _flat = {
    params ["_pts"];
    private _out = [];
    if !(_pts isEqualType []) exitWith {_out};
    {
        if (_x call _isXY) then {
            _out pushBack (_x # 0);
            _out pushBack (_x # 1);
        };
    } forEach _pts;
    _out
};

([_heli] call fza_mpd_fnc_tsdSegments) params ["_route", "_live"];

// What stays put in the world, built again only when it changes: the same points and route as last time send the
// same text, so the page is not sent it again either (fza_mpd_fnc_htmlPush)
private _worldSrc = [_points select [0, _dynStart], _route];
(_ctrl getVariable ["fza_mpd_tsdWorld", [[], ""]]) params ["_lastWorldSrc", "_worldJson"];
if (_worldJson == "" || {_worldSrc isNotEqualTo _lastWorldSrc}) then {
    _worldJson = format ['{"pts":%1,"segs":%2', toJSON ([0, _dynStart min count _points] call _entries), toJSON ([_route] call _segs)];
    // A copy, as the positions are the DMS's and FCR's own arrays
    _ctrl setVariable ["fza_mpd_tsdWorld", [+_worldSrc, _worldJson]];
};
private _dynPts = [_dynStart min count _points, count _points] call _entries;

// The zones, areas and lines (fza_mpd_fnc_tsdZoneItems), flattened again only when the items change: [closed, dash,
// colour, [x1, y1, ...]]
private _zoneItems = _state getOrDefault ["zoneItems", []];
(_ctrl getVariable ["fza_mpd_tsdPolys", [[], "[]"]]) params ["_polySrc", "_polysJson"];
if !(_zoneItems isEqualRef _polySrc) then {
    _polysJson = toJSON (_zoneItems apply {
        _x params ["_pts", "_closed", "_color", "_style"];
        [_closed, _style, _color, [_pts] call _flat]
    });
    _ctrl setVariable ["fza_mpd_tsdPolys", [_zoneItems, _polysJson]];
};

// The zone being drawn on ZN: [closed, colour, [x1, y1, ...]]
private _draft = ([_heli, _mpdIndex, _state, _persistState, _framePos, _frameHeading, _tsdScale, _ctr] call fza_mpd_fnc_tsdZoneDraft) apply {
    _x params ["_pts", "_closed", "_color"];
    [_closed, _color, [_pts] call _flat]
};

if (_defsGrew) then {
    private _out = createHashMap;
    {
        if (_y isNotEqualTo []) then {_out set [_x, _y select [0, 6]]};
    } forEach _defs;
    _ctrl setVariable ["fza_mpd_tsdDefsJson", toJSON _out];
};

// The cursor's spokes are drawn by the page round a point it is on
private _cursor = _heli getVariable ["fza_mpd_cursor", []];
private _cursorXY = [[], [_cursor param [1, 0], _cursor param [2, 0]]] select (_highlight isNotEqualTo []);

// The map's frame; one that isn't all finite numbers clears the map rather than losing the payload
private _frame = [_framePos param [0, 0], _framePos param [1, 0], _frameHeading, _tsdScale, _ctr # 0, _ctr # 1];
if (_frame findIf {!(_x isEqualType 0) || {!finite _x}} != -1) then {_frame = []};
if !(_highlight isEqualTypeArray [0, 0]) then {_highlight = []};
if !(_cursorXY call _isXY) then {_cursorXY = []};

[_ctrl, "fzaTSD.defs", _ctrl getVariable ["fza_mpd_tsdDefsJson", "{}"], "d"] call fza_mpd_fnc_htmlPush;
[_ctrl, "fzaTSD.world", _worldJson + ',"polys":' + _polysJson + "}", "w"] call fza_mpd_fnc_htmlPush;
[_ctrl, "fzaTSD.frame", format ['{"f":%1,"hl":%2,"cur":%3,"pts":%4,"segs":%5,"draft":%6}'
    , ["null", toJSON _frame] select (_frame isNotEqualTo [])
    , toJSON _highlight
    , toJSON _cursorXY
    , toJSON _dynPts
    , toJSON ([_live] call _segs)
    , toJSON _draft
    ], "f"] call fza_mpd_fnc_htmlPush;
