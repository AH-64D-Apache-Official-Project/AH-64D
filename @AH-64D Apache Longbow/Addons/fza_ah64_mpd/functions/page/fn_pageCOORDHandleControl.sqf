params ["_heli", "_mpdIndex", "_control", "_state", "_persistState"];

#include "\fza_ah64_mpd\headers\tsd.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _coordPage     = _state get "pageNumber";
private _tsdState      = _state get "tsdState";

switch (_control) do {
    case "t5": {
        [_heli, _mpdIndex, "tsd", _tsdState] call fza_mpd_fnc_setCurrentPage;
    };
    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };
    case "b2": {
        _coordPage = _coordPage - 1;
        if (_coordPage <= 0) then {_coordPage = MFD_COORD_NUMPAGES;};
        _persistState set ["pageNumber", _coordPage];
    };    
    case "b3": {
        _coordPage = _coordPage + 1;
        if (_coordPage > MFD_COORD_NUMPAGES) then {_coordPage = 1;};
        _persistState set ["pageNumber", _coordPage];
    };
};