params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"

private _variant = _state get "subPageVarPage" select 1;

switch (_variant) do {
    case 0: {   //Top level TSD page
        switch (_control) do {
            case "b6": {    //THRT
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "l2": {    //THRT add subpage
                _state set ["subPageVarPage", TSD_THRT_ADD];
                _state set ["thrtAddType",     POINT_TYPE_TG];
            };
            case "l3": {    //THRT del subpage
                _state set ["subPageVarPage", TSD_THRT_DEL_NOPOINTSEL];
            };
            case "l4": {    //THRT edt subpage
                _state set ["subPageVarPage", TSD_THRT_EDT_NOPOINTSEL];
            };
            case "l5": {    //THRT sto subpage
                _state set ["subPageVarPage", TSD_THRT_STO];
            };
        };
    };
    case 1: {   //THRT > ADD
        case "b6": {    //THRT
            _state set ["subPageVarPage", TSD_ROOT];
        };
        case "l2": {
            _state set ["subPageVarPage", TSD_THRT];
        };
        case "l3": {    //Set add type to WP
            _state set ["wptAddType", POINT_TYPE_WP];
        };
        case "l4": {    //Set add type to HZ
            _state set ["wptAddType", POINT_TYPE_HZ];
        };
        case "l5": {    //Set add type to CM
            _state set ["wptAddType", POINT_TYPE_CM];
        };
    };
    case 2: {   //DEL > DEL no point selected
        case "b6": {    //THRT
            _state set ["subPageVarPage", TSD_ROOT];
        };
        case "l3": {
            _state set ["subPageVarPage", TSD_THRT];
        };
    };
    case 3: {   //THRT > DEL point selected
        case "b6": {    //THRT
            _state set ["subPageVarPage", TSD_ROOT];
        };
        case "l3": {
            _state set ["subPageVarPage", TSD_THRT];
        };
    };
    case 4: {   //WPT > EDT no point selected
        case "b6": {    //THRT
            _state set ["subPageVarPage", TSD_ROOT];
        };
        case "l4": {
            _state set ["subPageVarPage", TSD_THRT];
        };
    };
    case 5: {   //WPT > EDT point selected
        case "b6": {    //THRT
            _state set ["subPageVarPage", TSD_ROOT];
        };
        case "l4": {
            _state set ["subPageVarPage", TSD_THRT];
        };
    };
    case 6: {   //WPT > STO page
        case "b6": {    //THRT
            _state set ["subPageVarPage", TSD_ROOT];
        };
        case "l5": {
            _state set ["subPageVarPage", TSD_THRT];
        };
    };
    case 7: {   //WPT > XMIT page

    };
};