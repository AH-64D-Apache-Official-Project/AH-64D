params ["_heli", "_mpdIndex", "_control", "_state"];

#include "\fza_ah64_mpd\headers\tsd.hpp"

switch (_control) do {
    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };
    case "b2": {
        private _newMode = ["atk", "nav"] select (_heli getVariable "fza_mpd_tsdMode" == "atk");
        _heli setVariable ["fza_mpd_tsdMode", _newMode];
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
        };
    };
    case 1: { // Show
        _this call fza_mpd_fnc_tsdShowHandleControl;
    };
    case 2: { // Wpt
        _this call fza_mpd_fnc_tsdWptHandleControl;
    };
};