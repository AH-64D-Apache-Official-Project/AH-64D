params ["_heli", "_mpdIndex", "_control", "_state", "_persistState"];

#include "\fza_ah64_mpd\headers\tsd.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _coordPage     = _state get "pageNumber";
private _tsdState      = _state get "tsdState";
private _pageNumberMax = _state get "pageNumberMax";
private _pageType      = _state get "pageType";
private _pointselected = _state get "PointSelected";

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
        if (_pageType != "WPTHZ") then {
            _state set ["pageType", "WPTHZ"];
            _state set ["pageNumber", 1];
            _state set ["PointSelected", -1];
        };
    };
    case "t2": {
        if (_pageType != "CTRLM") then {
            _state set ["pageType", "CTRLM"];
            _state set ["pageNumber", 1];
            _state set ["PointSelected", -1];
        };
    };
    /*case "t3": {
        if (_pageType != "LINE") then {
            _state set ["pageType", "LINE"];
            _state set ["pageNumber", 1];
            _state set ["PointSelected", -1];
        };
    };*/
    /*case "t4": {
        if (_pageType != "AREA") then {
            _state set ["pageType", "AREA"];
            _state set ["pageNumber", 1];
            _state set ["PointSelected", -1];
        };
    };*/
    case "t5": {
        if (_pageType != "COORD") then {
            _state set ["pageType", "COORD"];
            _state set ["pageNumber", 1];
            _state set ["PointSelected", -1];
        } else {
            [_heli, _mpdIndex, "tsd", _tsdState] call fza_mpd_fnc_setCurrentPage;
        };
    };
    case "t6": {
        if (_pageType != "SHOT") then {
            _state set ["pageType", "SHOT"];
            _state set ["pageNumber", 1];
            _state set ["PointSelected", -1];
        };
    };

    //point selection
    case "r1": {
        if (_pointselected == 1) then {
            _state set ["PointSelected", -1];
        } else {
            _state set ["PointSelected", 1];
        };
    };
    case "r2": {
        if (_pointselected == 2) then {
            _state set ["PointSelected", -1];
        } else {
            _state set ["PointSelected", 2];
        };
    };
    case "r3": {
        if (_pageType == "COORD" && _coordPage == 9) exitwith {};
        if (_pointselected == 3) then {
            _state set ["PointSelected", -1];
        } else {
            _state set ["PointSelected", 3];
        };
    };
    case "r4": {
        if (_pageType == "COORD" && _coordPage == 9) exitwith {};
        if (_pointselected == 4) then {
            _state set ["PointSelected", -1];
        } else {
            _state set ["PointSelected", 4];
        };
    };
    case "r5": {
        if (_pageType == "COORD" && _coordPage == 9) exitwith {};
        if (_pointselected == 5) then {
            _state set ["PointSelected", -1];
        } else {
            _state set ["PointSelected", 5];
        };
    };
    case "r6": {
        if (_pageType == "COORD" && _coordPage == 9) exitwith {};
        if (_pointselected == 6) then {
            _state set ["PointSelected", -1];
        } else {
            _state set ["PointSelected", 6];
        };
    };
};