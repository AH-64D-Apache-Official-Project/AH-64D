params ["_heli", "_mpdIndex", "_control", "_state", "_persistState"];

#include "\fza_ah64_mpd\headers\tsd.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _abrPage        = _heli Getvariable "fza_ah64_abr_PageNum";
private _abrPageReturn  = _heli Getvariable "fza_ah64_abr_PageReturn";
private _abrPageNum     = _abrPage  # _mpdIndex;

switch (_control) do {
    case "t2": {
        _abrPageReturn set [_mpdIndex, [1]];
        [_heli, _mpdIndex, "ase"] call fza_mpd_fnc_setCurrentPage;
        _abrPage set [_mpdIndex, 1];
    };
    case "t4": {
        [_heli, _mpdIndex, "tsd"] call fza_mpd_fnc_setCurrentPage;
        _abrPage set [_mpdIndex, 1];
    };
    case "b1": {
        _abrPageReturn set [_mpdIndex, [1]];
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
        _abrPage set [_mpdIndex, 1];
    };
    case "b2": {
        private _set = 1;
        if (_abrPageNum > 1) then {_set = _abrPageNum - 1;};
        _abrPage set [_mpdIndex, _set];
    };    
    case "b3": {
        private _set = 3;
        if (_abrPageNum < 3) then {_set = _abrPageNum + 1;};
        _abrPage set [_mpdIndex, _set];
    };
    case "b4": {
        _abrPageReturn set [_mpdIndex,TSD_WPT];
        [_heli, _mpdIndex, "tsd"] call fza_mpd_fnc_setCurrentPage;
        _abrPage set [_mpdIndex, 1];
    };
    case "b5": {
        _abrPageReturn set [_mpdIndex,TSD_RTE];
        [_heli, _mpdIndex, "tsd"] call fza_mpd_fnc_setCurrentPage;
        _abrPage set [_mpdIndex, 1];
    };
    case "b6": {
        _abrPageReturn set [_mpdIndex,TSD_THRT];
        [_heli, _mpdIndex, "tsd"] call fza_mpd_fnc_setCurrentPage;
        _abrPage set [_mpdIndex, 1];
    };
};