params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"

private _variant = _state get "subPageVarPage" select 1;

switch (_variant) do {
    case 0: {   //RTE page
        switch (_control) do {
            case "l4": {     //RTE DIR sub-page
                _state set ["subPageVarPage", TSD_RTE_DIR_NOPOINTSEL];
            };
            case "b4": {    //To WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
            case "b5": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "b6": {    //To THRT page
                _state set ["subPageVarPage", TSD_THRT];
            };
        };
    };
    case 1: {   //ADD sub-page
        switch (_control) do {
            //Not implemented
        };
    };
    case 2: {   //DEL sub-page
        switch (_control) do {
            //Not implemented
        };
    };
    case 3: {   //DIR no point selected sub-page
        switch (_control) do {
            case "l1": {    //Select Point

            };
            case "l4": {     //Return to RTE page
                _state set ["subPageVarPage", TSD_RTE];
            };
            case "b4": {    //To WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
            case "b5": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "b6": {    //To THRT page
                _state set ["subPageVarPage", TSD_THRT];
            };
        };
    };
    case 4: {   //DIR point selected sub-page
        switch (_control) do {
            case "l1": {    //Select Point

            };
            case "l4": {     //Return to RTE page
                _state set ["subPageVarPage", TSD_RTE];
            };
            case "b4": {    //To WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
            case "b5": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "b6": {    //To THRT page
                _state set ["subPageVarPage", TSD_THRT];
            };
        };
    };
    case 5: {   //RVW sub-page
        switch (_control) do {
            //Not implemented
        };
    };
    case 6: {   //RTM sub-page
        switch (_control) do {
            //Not implemented
        };
    };
};