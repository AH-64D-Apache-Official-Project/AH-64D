#define POINTMODE_THREAT
#include "fn_tsdWPTHandleControl.sqf"

switch (_variant) do {
    case 0: {   //Top level TSD page
        switch (_control) do {
            case "b6": {    //WPT
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "t4": {
                [_heli, _mpdIndex, "abr", ["tsdState"] createHashMapFromArray [_state]] call fza_mpd_fnc_setCurrentPage;
            };
        };
    };
};