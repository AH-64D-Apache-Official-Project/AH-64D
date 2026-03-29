params ["_heli", "_mpdIndex", "_control", "_state", "_persistState"];

#include "\fza_ah64_mpd\headers\tsd.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _coordPage     = _state get "pageNumber";
private _tsdState      = _state get "tsdState";
private _pageNumberMax = _state get "pageNumberMax";
private _pageType      = _state get "pageType";
private _pointselected = _state get "PointSelected";
private _shotatdel     = _state get "shotatdel";

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

    //point selection
    case "r1": {
        if (_pageType == 6) exitwith {};
        if (_pointselected == 1) then {
            _state set ["PointSelected", -1];
        } else {
            _state set ["PointSelected", 1];
        };
    };
    case "r2": {
        if (_pageType == 6) exitwith {};
        if (_pointselected == 2) then {
            _state set ["PointSelected", -1];
        } else {
            _state set ["PointSelected", 2];
        };
    };
    case "r3": {
        if (_pageType == 6) exitwith {};
        if (_pageType == 5 && _coordPage == 9) exitwith {};
        if (_pointselected == 3) then {
            _state set ["PointSelected", -1];
        } else {
            _state set ["PointSelected", 3];
        };
    };
    case "r4": {
        if (_pageType == 6) exitwith {};
        if (_pageType == 5 && _coordPage == 9) exitwith {};
        if (_pointselected == 4) then {
            _state set ["PointSelected", -1];
        } else {
            _state set ["PointSelected", 4];
        };
    };
    case "r5": {
        if (_pageType == 6) exitwith {};
        if (_pageType == 5 && _coordPage == 9) exitwith {};
        if (_pointselected == 5) then {
            _state set ["PointSelected", -1];
        } else {
            _state set ["PointSelected", 5];
        };
    };
    case "r6": {
        if (_pageType == 6) exitwith {};
        if (_pageType == 5 && _coordPage == 9) exitwith {};
        if (_pointselected == 6) then {
            _state set ["PointSelected", -1];
        } else {
            _state set ["PointSelected", 6];
        };
        
    };

    case "l3": {
        if (_pageType == 6) then {
            if (_shotatdel == 0) then {
                _state set ["shotatdel", 1];
            } else {
                _state set ["shotatdel", 0];
            };
        };
    }
};