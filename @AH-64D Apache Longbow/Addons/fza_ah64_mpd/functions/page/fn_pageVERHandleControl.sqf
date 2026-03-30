#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli", "_mpdIndex", "_control", "_state"];

private _verPage       = _state get "pageNumber";
private _pageNumberMax = _state get "pageNumberMax";

switch(_control) do {
    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };
    case "b6": {
        [_heli, _mpdIndex, "wca"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t1": {
        [_heli, _mpdIndex, "dtu"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t5": {
        [_heli, _mpdIndex, "DMS"] call fza_mpd_fnc_setCurrentPage;
    };
    case "b2": {
        _verPage = (_verPage - 1) max 1;
        _state set ["pageNumber", _verPage];
    };    
    case "b3": {
        _verPage =( _verPage + 1) min _pageNumberMax;
        _state set ["pageNumber", _verPage];
    };
};