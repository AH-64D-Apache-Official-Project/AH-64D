/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_cursorPoint

Description:
    The point an MPD cursor position is on, on a TSD page that takes a point
    from the map: WPT (waypoints, hazards and control measures) and THRT
    (targets and threats), at their top level, DEL and EDT, and RTE ADD
    (waypoints, hazards and control measures). Of the points the TSD draws
    (fza_mpd_fnc_pageTSDDraw), the nearest within reach of the cursor.

Parameters:
    _heli - The helicopter
    _side - 0 left MPD, 1 right
    _posX - Cursor X, 0 left to 1 right
    _posY - Cursor Y, 0 top to 1 bottom

Returns:
    The point ID ([type, ID]), or [] for none

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
params ["_heli", "_side", "_posX", "_posY"];

((_heli getVariable "fza_mpd_mpdState") # _side) params ["_page", "", "", "", "_state", "_persistState"];
if (toLower _page != "tsd") exitWith {[]};
(_state get "subPageVarPage") params ["_subPage", "_variant"];
private _types = switch (true) do {
    case (_subPage == 2 && {_variant in [0, 2, 3, 4, 5]}): {[POINT_TYPE_WP, POINT_TYPE_HZ, POINT_TYPE_CM]};
    case (_subPage == 4 && {_variant in [0, 2, 3, 4, 5]}): {[POINT_TYPE_TG]};
    case (_subPage == 3 && {_variant in [1, 2]}): {[POINT_TYPE_WP, POINT_TYPE_HZ, POINT_TYPE_CM]};
    default {[]};
};
if (_types isEqualTo []) exitWith {[]};

// Where fza_mpd_fnc_uiDrawPoint draws them
private _tsd = _persistState get _page;
private _scale = 0.125 * 5 / (_tsd get "tsdScale");
private _ctrY = 0.75 - 0.25 * (_tsd get "ctr");
private _heliPos = getPosASL _heli;
private _heading = direction _heli;

private _best = [];
private _bestDistance = MPD_CURSOR_POINT_REACH ^ 2;
{
    _x params ["_armaPos", "_id"];
    if !((_id # 0) in _types) then {continue};
    private _theta = [_heli, _heliPos # 0, _heliPos # 1, _armaPos # 0, _armaPos # 1, _heading] call fza_fnc_relativeDirection;
    private _r = (_heliPos distance2D _armaPos) * _scale;
    private _distance = (0.5 + sin _theta * _r - _posX) ^ 2 + (_ctrY - cos _theta * _r - _posY) ^ 2;
    if (_distance < _bestDistance) then {
        _bestDistance = _distance;
        _best = _id;
    };
} forEach (_state getOrDefault ["cursorPoints", []]);

_best
