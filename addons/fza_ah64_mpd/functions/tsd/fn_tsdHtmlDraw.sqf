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
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_dms\headers\constants.h"
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

// The points' idents are defined on the control (fza_mpd_fnc_htmlPoints), as tuned for the TSD
private _tune = fza_mpd_threatTune getOrDefault ["tsd", MPD_THREAT_TUNE_TSD];
// A position the page can take: two finite numbers. toJSON writes a NaN or an infinity as text JSON cannot parse,
// which would lose the whole payload
private _isXY = {
    _this isEqualType [] && {count _this >= 2} && {(_this # 0) isEqualType 0} && {(_this # 1) isEqualType 0}
        && {finite (_this # 0)} && {finite (_this # 1)}
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
// same text, so the page is not sent it again either (fza_mpd_fnc_htmlPush). Retuning the threat symbols redefines
// the idents, so builds it again too.
private _worldPoints = _points select [0, _dynStart];
private _worldSrc = [_worldPoints, _route, missionNamespace getVariable ["fza_mpd_threatTuneVersion", 0]];
(_ctrl getVariable ["fza_mpd_tsdWorld", [[], ""]]) params ["_lastWorldSrc", "_worldJson"];
if (_worldJson == "" || {_worldSrc isNotEqualTo _lastWorldSrc}) then {
    _worldJson = format ['{"pts":%1,"segs":%2', toJSON ([_ctrl, _worldPoints, _tune] call fza_mpd_fnc_htmlPoints), toJSON ([_route] call _segs)];
    // A copy, as the positions are the DMS's and FCR's own arrays
    _ctrl setVariable ["fza_mpd_tsdWorld", [+_worldSrc, _worldJson]];
};
private _dynPts = [_ctrl, _points select [_dynStart min count _points, count _points], _tune] call fza_mpd_fnc_htmlPoints;

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

// The cursor's spokes are drawn by the page round a point it is on
private _cursor = _heli getVariable ["fza_mpd_cursor", []];
private _cursorXY = [[], [_cursor param [1, 0], _cursor param [2, 0]]] select (_highlight isNotEqualTo []);

// The map's frame; one that isn't all finite numbers clears the map rather than losing the payload
private _frame = [_framePos param [0, 0], _framePos param [1, 0], _frameHeading, _tsdScale, _ctr # 0, _ctr # 1];
if (_frame findIf {!(_x isEqualType 0) || {!finite _x}} != -1) then {_frame = []};
if !(_highlight isEqualTypeArray [0, 0]) then {_highlight = []};
if !(_cursorXY call _isXY) then {_cursorXY = []};

[_ctrl, "fzaTSD.defs", [_ctrl] call fza_mpd_fnc_htmlDefsJson, "d"] call fza_mpd_fnc_htmlPush;
[_ctrl, "fzaTSD.world", _worldJson + ',"polys":' + _polysJson + "}", "w"] call fza_mpd_fnc_htmlPush;
[_ctrl, "fzaTSD.frame", format ['{"f":%1,"hl":%2,"cur":%3,"pts":%4,"segs":%5,"draft":%6}'
    , ["null", toJSON _frame] select (_frame isNotEqualTo [])
    , toJSON _highlight
    , toJSON _cursorXY
    , toJSON _dynPts
    , toJSON ([_live] call _segs)
    , toJSON _draft
    ], "f"] call fza_mpd_fnc_htmlPush;
