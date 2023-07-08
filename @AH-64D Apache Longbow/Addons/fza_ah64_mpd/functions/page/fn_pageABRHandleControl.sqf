params ["_heli", "_mpdIndex", "_control", "_state", "_persistState"];

#include "\fza_ah64_mpd\headers\tsd.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _abrPage        = _persistState get "pageNumber";
private _tsdState      = _state get "tsdState";

switch (_control) do {
    case "t2": {
        [_heli, _mpdIndex, "ase"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t4": {
        [_heli, _mpdIndex, "tsd", _tsdState] call fza_mpd_fnc_setCurrentPage;
    };
    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };
    case "b2": {
        _abrPage = _abrPage - 1;
        if (_abrPage <= 0) then {_abrPage = MFD_ABR_NUMPAGES;};
        _persistState set ["pageNumber", _abrPage];
    };    
    case "b3": {
        _abrPage = _abrPage + 1;
        if (_abrPage > MFD_ABR_NUMPAGES) then {_abrPage = 1;};
        _persistState set ["pageNumber", _abrPage];
    };
    case "b4": {
        [_heli, _mpdIndex, "tsd", ["subPageVarPage"] createHashMapFromArray [TSD_WPT]] call fza_mpd_fnc_setCurrentPage;
    };
    case "b5": {
        [_heli, _mpdIndex, "tsd", ["subPageVarPage"] createHashMapFromArray [TSD_RTE]] call fza_mpd_fnc_setCurrentPage;
    };
    case "b6": {
        [_heli, _mpdIndex, "tsd", ["subPageVarPage"] createHashMapFromArray [TSD_THRT]] call fza_mpd_fnc_setCurrentPage;
    };
};