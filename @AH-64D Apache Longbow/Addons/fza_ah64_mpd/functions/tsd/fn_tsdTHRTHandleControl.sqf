#define POINTMODE_THREAT
#include "fn_tsdWPTHandleControl.sqf"

private _abrPageReturn  = _heli Getvariable "fza_ah64_abr_PageReturn";

switch (_variant) do {
    case 0: {   //Top level TSD page
        switch (_control) do {
            case "b6": {    //WPT
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "t4": {
                [_heli, _mpdIndex, "abr"] call fza_mpd_fnc_setCurrentPage;
                _abrPageReturn set [_mpdIndex, TSD_THRT];
            };
        };
    };
};