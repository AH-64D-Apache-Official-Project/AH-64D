params ["_heli", "_mpdIndex", "_control", "_state", "_persistState"];

#include "\fza_ah64_mpd\headers\tsd.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _coordPage     = _state get "pageNumber";
private _tsdState      = _state get "tsdState";
private _pageNumberMax = _state get "pageNumberMax";
private _pageType      = _state get "pageType";
private _pointselected = _state get "PointSelected";
private _shotatdel     = _state get "shotatdel";
private _pagePoints    = _state getOrDefault ["pagePoints", []];

switch (_control) do {
    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };
    case "b2": {
        _coordPage = _coordPage - 1;
        if (_coordPage <= 0) then {_coordPage = _pageNumberMax;};
        _state set ["pageNumber", _coordPage];
        _state set ["PointSelected", -1];
    };
    case "b3": {
        _coordPage = _coordPage + 1;
        if (_coordPage > _pageNumberMax) then {_coordPage = 1;};
        _state set ["pageNumber", _coordPage];
        _state set ["PointSelected", -1];
    };
    case "t1": {
        if (_pageType != 1) then {
            _state set ["pageType", 1];
            _state set ["pageNumber", 1];
            _state set ["PointSelected", -1];
            _state set ["shotatdel", 0];
        };
    };
    case "t2": {
        if (_pageType != 2) then {
            _state set ["pageType", 2];
            _state set ["pageNumber", 1];
            _state set ["PointSelected", -1];
            _state set ["shotatdel", 0];
        };
    };
    /*case "t3": {
        if (_pageType != 3) then {
            _state set ["pageType", 3];
            _state set ["pageNumber", 1];
            _state set ["PointSelected", -1];
            _state set ["shotatdel", 0];
        };
    };*/
    /*case "t4": {
        if (_pageType != 4) then {
            _state set ["pageType", 4];
            _state set ["pageNumber", 1];
            _state set ["PointSelected", -1];
            _state set ["shotatdel", 0];
        };
    };*/
    case "t5": {
        if (_pageType != 5) then {
            _state set ["pageType", 5];
            _state set ["pageNumber", 1];
            _state set ["PointSelected", -1];
            _state set ["shotatdel", 0];
        } else {
            [_heli, _mpdIndex, "tsd", _tsdState] call fza_mpd_fnc_setCurrentPage;
        };
    };
    case "t6": {
        if (_pageType != 6) then {
            _state set ["pageType", 6];
            _state set ["pageNumber", 1];
            _state set ["PointSelected", -1];
        };
    };

    //point selection: R1-R6 expand a line's point
    case "r1";
    case "r2";
    case "r3";
    case "r4";
    case "r5";
    case "r6": {
        if (_pageType == 6) exitWith {};
        private _line = ["r1", "r2", "r3", "r4", "r5", "r6"] find _control;
        if (_line >= count _pagePoints) exitWith {};
        _state set ["PointSelected", [_line + 1, -1] select (_pointselected == _line + 1)];
    };

    // L1-L6 make a line's point the crew station's acquisition source; L3 on SHOT AT deletes
    case "l1";
    case "l2";
    case "l3";
    case "l4";
    case "l5";
    case "l6": {
        if (_pageType == 6) exitWith {
            if (_control == "l3") then {
                _state set ["shotatdel", [1, 0] select (_shotatdel == 1)];
            };
        };
        private _line = ["l1", "l2", "l3", "l4", "l5", "l6"] find _control;
        if (_line >= count _pagePoints) exitWith {};
        [_heli, (_pagePoints # _line) call fza_dms_fnc_pointToString] call fza_fnc_targetingAcqSet;
    };
};
