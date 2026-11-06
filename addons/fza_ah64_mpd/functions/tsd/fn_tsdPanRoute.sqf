/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_tsdPanRoute

Description:
    The current route as the PAN page scrolls along it: its points, where they
    are, how far along the route each is, and how far along it the map is
    panned. That is where the route buttons last panned to, or else the point
    nearest the map's place.

Parameters:
    _heli - The helicopter
    _tsd  - The TSD's persistent state on that MPD

Returns:
    [point IDs, positions, distances along the route in metres, panned distance or -1 with no route]

Examples:
    --- Code
    ([_heli, _tsd] call fza_mpd_fnc_tsdPanRoute) params ["_ids", "_positions", "_distances", "_along"];
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_dms\headers\constants.h"
params ["_heli", "_tsd"];

private _routeData = _heli getVariable ["fza_ah64_routeData", []];
private _route = _routeData param [_heli getVariable ["fza_ah64_routeSelected", 0], []];

private _ids = [];
private _positions = [];
private _distances = [];
{
    // The same point twice in a row is one stop
    if (_ids isNotEqualTo [] && {(_ids select -1) isEqualTo _x}) then {continue};
    private _pos = [_heli, _x, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;
    if (isNil "_pos") then {continue};
    if (_positions isEqualTo []) then {
        _distances pushBack 0;
    } else {
        _distances pushBack ((_distances select -1) + ((_positions select -1) distance2D _pos));
    };
    _ids pushBack _x;
    _positions pushBack _pos;
} forEach _route;

private _along = -1;
if (_positions isNotEqualTo []) then {
    _along = _tsd getOrDefault ["panRte", -1];
    if (_along < 0) then {
        private _place = ([_heli, _tsd] call fza_mpd_fnc_tsdFrame) # 0;
        private _nearest = 0;
        {
            if ((_x distance2D _place) < ((_positions # _nearest) distance2D _place)) then {_nearest = _forEachIndex};
        } forEach _positions;
        _along = _distances # _nearest;
    };
    _along = (_along max 0) min (_distances select -1);
};

[_ids, _positions, _distances, _along]
