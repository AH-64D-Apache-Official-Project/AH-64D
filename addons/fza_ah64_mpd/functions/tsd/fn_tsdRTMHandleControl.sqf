// The route menu: NEW makes a route current, DELETE empties one after YES, REVERSE ROUTE turns the current one round
params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\tsd.hpp"

private _page    = _state getOrDefault ["rtmPage", 0];
private _confirm = _state getOrDefault ["rtmConfirm", -1];

// The active point of the current route gone: no next point, unless it is a direct-to off the route
private _clearActive = {
    _heli setVariable ["fza_ah64_routeCurPoint", -1, true];
    _heli setVariable ["fza_dms_routeNext", [[], [0, 0, 0]], true];
    [_heli, "fza_ah64_wptAprch", [-1, false]] call fza_fnc_updateNetworkGlobal;
};

private _choose = {
    params ["_route"];
    if (_state getOrDefault ["rtmDelete", 0] == 1) exitWith {
        _state set ["rtmConfirm", _route];
    };
    if (_route == _heli getVariable "fza_ah64_routeSelected") exitWith {};
    private _points = (_heli getVariable "fza_ah64_routeData") # _route;
    private _direct = ((_heli getVariable "fza_dms_routeNext") # 1) isNotEqualTo [0, 0, 0];
    _heli setVariable ["fza_ah64_routeSelected", _route, true];
    _heli setVariable ["fza_mpd_tsdRteCurrentRvw", -1];
    _state set ["routeScroll", 0];
    if (_points isEqualTo []) exitWith {
        if (_direct && {(_heli getVariable "fza_ah64_routeCurPoint") == -1}) exitWith {};
        call _clearActive;
    };
    [_heli, _points # 0] call fza_dms_fnc_routeSetDir;
    _heli setVariable ["fza_ah64_routeCurPoint", 0, true];
    [_heli, "fza_ah64_wptAprch", [-1, false]] call fza_fnc_updateNetworkGlobal;
};

private _delete = {
    private _routeData = _heli getVariable "fza_ah64_routeData";
    _routeData set [_confirm, []];
    _heli setVariable ["fza_ah64_routeData", _routeData, true];
    if (_confirm == _heli getVariable "fza_ah64_routeSelected") then {
        _heli setVariable ["fza_mpd_tsdRteCurrentRvw", -1];
        _state set ["routeScroll", 0];
        if ((_heli getVariable "fza_ah64_routeCurPoint") != -1) then {call _clearActive};
    };
};

// A route point active: after reversing, the point before it, or the last point if it was the first; a direct-to stays
private _reverse = {
    private _routeData = _heli getVariable "fza_ah64_routeData";
    private _points = _routeData # (_heli getVariable "fza_ah64_routeSelected");
    private _count = count _points;
    if (_count < 2) exitWith {};
    reverse _points;
    private _index = _heli getVariable "fza_ah64_routeCurPoint";
    if (_index != -1) then {
        private _newIndex = _count - 1 - _index;
        if (((_heli getVariable "fza_dms_routeNext") # 1) isEqualTo [0, 0, 0] && {_index > 0}) then {
            _newIndex = _count - _index;
            [_heli, _points # _newIndex] call fza_dms_fnc_routeSetDir;
            [_heli, "fza_ah64_wptAprch", [-1, false]] call fza_fnc_updateNetworkGlobal;
        };
        _heli setVariable ["fza_ah64_routeCurPoint", _newIndex, true];
    };
    _heli setVariable ["fza_ah64_routeData", _routeData, true];
};

private _endDelete = {
    _state set ["rtmConfirm", -1];
    _state set ["rtmDelete", 0];
};

switch (_control) do {
    case "t1": {[5 * _page] call _choose};
    case "t2": {[5 * _page + 1] call _choose};
    case "t3": {[5 * _page + 2] call _choose};
    case "t4": {[5 * _page + 3] call _choose};
    case "t5": {[5 * _page + 4] call _choose};
    case "l2": {
        if (_confirm < 0) exitWith {};
        call _delete;
        call _endDelete;
    };
    case "l3": {
        if (_confirm < 0) exitWith {};
        call _endDelete;
    };
    case "l4": {call _endDelete};
    case "l5": {
        _state set ["rtmConfirm", -1];
        _state set ["rtmDelete", 1];
    };
    case "l6": {
        _state set ["subPageVarPage", TSD_RTE];
    };
    case "r5": {call _reverse};
    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };
    case "b2": {
        _state set ["rtmPage", 0];
        _state set ["rtmConfirm", -1];
    };
    case "b3": {
        _state set ["rtmPage", 1];
        _state set ["rtmConfirm", -1];
    };
    case "b4": {
        _state set ["subPageVarPage", TSD_WPT];
    };
    case "b5": {
        _state set ["subPageVarPage", TSD_ROOT];
    };
    case "b6": {
        _state set ["subPageVarPage", TSD_THRT];
    };
};
