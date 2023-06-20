params ["_heli", "_mpdIndex", "_control", "_state", "_persistState"];

#include "\fza_ah64_mpd\headers\tsd.hpp"
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _showScale = (getUserMFDValue _heli) # MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_SCALE);

switch (_control) do {
    case "t2": {
        [_heli, _mpdIndex, "ase"] call fza_mpd_fnc_setCurrentPage;
    };
    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };
    case "b2": {
        private _newMode = ["atk", "nav"] select (_persistState get "mode" == "atk");
        _persistState set ["mode", _newMode];
    };    
};

switch (_state get "subPageVarPage" select 0) do {
    case 0: { // Root
        switch (_control) do {
            case "l6": {
                _state set ["subPageVarPage", TSD_SHOW]; //SHOW subpage
            };
            case "b4": {
                _state set ["subPageVarPage", TSD_WPT]; //WPT subpage
            };
            case "b5": {
                _state set ["subPageVarPage", TSD_RTE]; //RTE subpage
            };
            case "b6": {
                _state set ["subPageVarPage", TSD_THRT]; //THRT subpage
            };
            case "r1": {
                if (_showScale == -1) then {
                } else {
                    _heli setVariable ["fza_ah64_rangesetting", 50000];
                    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_SCALE), -1];
                };
            };
            case "r2": {
                if (_showScale == -1) then {
                    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_SCALE), 1];
                } else {
                    _heli setVariable ["fza_ah64_rangesetting", 25000];
                    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_SCALE), -1];
                };
            };
            case "r3": {
                if (_showScale == -1) then {
                    _persistState set ["ctr", 1 - (_persistState get "ctr")];
                } else {
                    _heli setVariable ["fza_ah64_rangesetting", 10000];
                    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_SCALE), -1];
                };
            };
            case "r4": {
                if (_showScale == -1) then {
                } else {
                    _heli setVariable ["fza_ah64_rangesetting", 5000];
                    _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_TEXT_IND_TSD_ROOT_SCALE), -1];
                };
            };
        };
    };
    case 1: { // SHOW
        _this call fza_mpd_fnc_tsdShowHandleControl;
    };
    case 2: { // WPT
        _this call fza_mpd_fnc_tsdWptHandleControl;
    };
    case 3: { //RTE
        _this call fza_mpd_fnc_tsdRteHandleControl;
    };
    case 4: { // THRT
        _this call fza_mpd_fnc_tsdThrtHandleControl;
    };
};