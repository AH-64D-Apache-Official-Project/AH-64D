/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_cursorPoint

Description:
    The point an MPD cursor position is on, on a TSD page that takes a point
    from the map: WPT (waypoints, hazards and control measures) and THRT
    (targets and threats), at their top level, DEL and EDT, RTE ADD
    (waypoints, hazards and control measures), RTE DIR (those and targets and
    threats), and CAQ (waypoints, hazards, control measures, targets and
    threats, and FCR targets). Of the points the TSD
    draws (fza_mpd_fnc_pageTSDDraw), the nearest within reach of the cursor.

Parameters:
    _heli - The helicopter
    _side - 0 left MPD, 1 right
    _posX - Cursor X, 0 left to 1 right
    _posY - Cursor Y, 0 top to 1 bottom

Returns:
    The point ID ([type, ID]), or [] for none. An FCR target's is
    [POINT_TYPE_FCR, its index in the FCR's displayed targets], as in the page
    state's cursorFcr.

Examples:
    --- Code
    [_heli, 1, 0.52, 0.4] call fza_mpd_fnc_cursorPoint
    // => [0, 3]
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_dms\headers\constants.h"
#include "\fza_ah64_mpd\headers\cursor.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"
params ["_heli", "_side", "_posX", "_posY"];

((_heli getVariable "fza_mpd_mpdState") # _side) params ["_page", "", "", "", "_state", "_persistState"];
if (toLower _page != "tsd") exitWith {[]};
(_state get "subPageVarPage") params ["_subPage", "_variant"];
private _caq = _subPage == 0 && {_state getOrDefault ["caq", 0] == 1};
private _types = switch (true) do {
    case (_caq): {[POINT_TYPE_WP, POINT_TYPE_HZ, POINT_TYPE_CM, POINT_TYPE_TG, POINT_TYPE_FCR]};
    case (_subPage == 2 && {_variant in [0, 2, 3, 4, 5]}): {[POINT_TYPE_WP, POINT_TYPE_HZ, POINT_TYPE_CM]};
    case (_subPage == 4 && {_variant in [0, 2, 3, 4, 5]}): {[POINT_TYPE_TG]};
    case (_subPage == 3 && {_variant in [1, 2]}): {[POINT_TYPE_WP, POINT_TYPE_HZ, POINT_TYPE_CM]};
    case (_subPage == 3 && {_variant in [4, 5]}): {[POINT_TYPE_WP, POINT_TYPE_HZ, POINT_TYPE_CM, POINT_TYPE_TG]};
    default {[]};
};
if (_types isEqualTo []) exitWith {[]};
if !([_heli, _side, _posX, _posY] call fza_mpd_fnc_cursorInArea) exitWith {[]};

// Where the TSD page draws them (fza_mpd_fnc_tsdHtmlDraw)
private _tsd = _persistState get _page;
private _scale = [_tsd] call fza_mpd_fnc_tsdScale;
private _ctrY = 0.75 - 0.25 * (_tsd get "ctr");
([_heli, _tsd] call fza_mpd_fnc_tsdFrame) params ["_heliPos", "_heading"];

private _best = [];
private _bestDistance = MPD_CURSOR_POINT_REACH ^ 2;
TSD_MAP_CLIP params ["_left", "_top", "_right", "_bottom"];
{
    _x params ["_armaPos", "_id"];
    if !((_id # 0) in _types) then {continue};
    private _screen = [_heliPos, _heading, _scale, [0.5, _ctrY], _armaPos] call fza_mpd_fnc_tsdWorldToScreen;
    // Not one outside the map border, which the TSD hides (ui\tsd\tsd.js)
    _screen params ["_sx", "_sy"];
    if (_sx < _left || {_sx > _right} || {_sy < _top} || {_sy > _bottom}) then {continue};
    private _distance = _screen distanceSqr [_posX, _posY];
    if (_distance < _bestDistance) then {
        _bestDistance = _distance;
        _best = _id;
    };
} forEach ((_state getOrDefault ["cursorPoints", []]) + ([[], (_state getOrDefault ["cursorFcr", []]) apply {[_x # 0, _x # 1]}] select _caq));

_best
