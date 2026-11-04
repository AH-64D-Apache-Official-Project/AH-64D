/* ----------------------------------------------------------------------------
Function: fza_mpd_fnc_tsdPanHandleControl

Description:
    The PAN page's buttons, which pan the frozen map:
    - T4, T6: the pan heading a degree left or right
    - T5 HDG: the pan heading entered on the KU
    - L1 POINT: to a point (W01, C51, T01) or a grid entered on the KU
    - L2, L5: to the route's next or last waypoint, the leg to it up the map
    - L3, L4: forward or back along the route, a twentieth of the map at a time

Parameters:
    _heli          - The helicopter
    _mpdIndex      - 0 left MPD, 1 right
    _control       - The button pressed
    _state         - The TSD page's state
    _persistState  - The TSD's persistent state on that MPD

Returns:
    Nothing

Examples:
    --- Code
    _this call fza_mpd_fnc_tsdPanHandleControl
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_dms\headers\constants.h"
params ["_heli", "_mpdIndex", "_control", "_state", "_persistState"];

// The map frozen at a place and heading, which LAST PAN returns to
private _panTo = {
    params ["_pos", "_heading", ["_along", -1]];
    private _frame = [[_pos # 0, _pos # 1, 0], (_heading + 360) mod 360];
    _persistState set ["frozen", _frame];
    _persistState set ["lastPan", +_frame];
    _persistState set ["panRte", _along];
};

// Along the route: the place that far along it, the leg it is on up the map
private _alongRoute = {
    params ["_along"];
    ([_heli, _persistState] call fza_mpd_fnc_tsdPanRoute) params ["", "_positions", "_distances"];
    if (_positions isEqualTo []) exitWith {};
    _along = (_along max 0) min (_distances select -1);
    private _leg = 0;
    {
        if (_x < _along && {_forEachIndex < count _positions - 1}) then {_leg = _forEachIndex};
    } forEach _distances;
    if (count _positions < 2) exitWith {[_positions # 0, ([_heli, _persistState] call fza_mpd_fnc_tsdFrame) # 1, _along] call _panTo};
    private _from = _positions # _leg;
    private _to = _positions # (_leg + 1);
    private _length = (_distances # (_leg + 1)) - (_distances # _leg);
    private _f = 0;
    if (_length > 0) then {_f = (_along - (_distances # _leg)) / _length};
    [_from vectorAdd ((_to vectorDiff _from) vectorMultiply _f), _from getDir _to, _along] call _panTo;
};

([_heli, _persistState] call fza_mpd_fnc_tsdFrame) params ["_framePos", "_frameHeading"];
([_heli, _persistState] call fza_mpd_fnc_tsdPanRoute) params ["", "", "_distances", "_along"];

switch (_control) do {
    case "t4": {
        [_framePos, _frameHeading - 1, _persistState getOrDefault ["panRte", -1]] call _panTo;
    };
    case "t6": {
        [_framePos, _frameHeading + 1, _persistState getOrDefault ["panRte", -1]] call _panTo;
    };
    case "t5": {
        private _callback = {
            params ["_heading", "_tsd", "_heli"];
            [] call fza_ku_fnc_stopInput;
            if (_heading > 360) exitWith {};
            private _frame = [(([_heli, _tsd] call fza_mpd_fnc_tsdFrame) # 0), _heading mod 360];
            _tsd set ["frozen", _frame];
            _tsd set ["lastPan", +_frame];
        };
        [_heli, "HDG", _callback, fza_ku_fnc_checkerInteger, _persistState, str ((round _frameHeading) mod 360), "pan heading"] call fza_ku_fnc_addPrompt;
    };
    case "l1": {
        // A point's ID or a grid, and the name to show for it
        private _checker = {
            params ["_input", "", "_heli"];
            private _id = [_heli, _input] call fza_dms_fnc_pointParse;
            if (_id isNotEqualTo []) exitWith {
                private _pos = [_heli, _id, POINT_GET_ARMA_POS] call fza_dms_fnc_pointGetValue;
                if (isNil "_pos") exitWith {false};
                [true, [_input, _pos]]
            };
            private _grid = [_input] call fza_ku_fnc_checkerGrid;
            if (_grid isEqualType false) exitWith {false};
            [true, [_input, _grid # 1]]
        };
        private _callback = {
            params ["_point", "_tsd", "_heli"];
            [] call fza_ku_fnc_stopInput;
            _point params ["_name", "_pos"];
            private _frame = [[_pos # 0, _pos # 1, 0], ([_heli, _tsd] call fza_mpd_fnc_tsdFrame) # 1];
            _tsd set ["frozen", _frame];
            _tsd set ["lastPan", +_frame];
            _tsd set ["panRte", -1];
            _tsd set ["panPoint", _name];
        };
        [_heli, "POINT", _callback, _checker, _persistState, "", "pan point"] call fza_ku_fnc_addPrompt;
    };
    case "l2": {
        private _next = _distances findIf {_x > _along + 1};
        if (_next >= 0) then {[_distances # _next] call _alongRoute};
    };
    case "l5": {
        private _last = -1;
        {
            if (_x < _along - 1) then {_last = _forEachIndex};
        } forEach _distances;
        if (_last >= 0) then {[_distances # _last] call _alongRoute};
    };
    case "l3";
    case "l4": {
        if (_distances isEqualTo []) exitWith {};
        // A twentieth of the map's height
        private _step = 0.05 / ([_persistState] call fza_mpd_fnc_tsdScale);
        [_along + ([-1, 1] select (_control == "l3")) * _step] call _alongRoute;
    };
};
