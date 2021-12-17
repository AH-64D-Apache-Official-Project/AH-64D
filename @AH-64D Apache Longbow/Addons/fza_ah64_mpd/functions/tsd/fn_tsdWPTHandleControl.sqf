params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"

private _phase = BOOLTONUM(_heli getVariable "fza_mpd_tsdMode" == "atk");
private _variant = _state get "subPageVarPage" select 1;

switch (_variant) do {
    case 0: {   //Top level TSD page
        switch (_control) do {
            case "b4": {    //WPT
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "l2": {    //WPT > ADD
                _state set ["subPageVarPage", TSD_WPT_ADD];
            };
            case "l3": {    //WPT > DEL
                _state set ["subPageVarPage", TSD_WPT_DEL_NOPOINTSEL];
            };
            case "l4": {    //WPT > EDT
                _state set ["subPageVarPage", TSD_WPT_EDT_NOPOINTSEL];
            };
            case "l5": {    //WPT > STO
                _state set ["subPageVarPage", TSD_WPT_STO];
            };
            case "l6": {    //WPT > XMIT
                _state set ["subPageVarPage", TSD_WPT_XMIT];
            };
        }
    };
    case 1: {   //WPT > ADD
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "l2": {    //Return to WPT > ADD
                _state set ["subPageVarPage", TSD_WPT];
            };
        }
    };
    case 2: {   //WPT > DEL no point selected
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "l3": {    //Do not delete - "No", return to WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
            //case "l2" will delete the selected point
            case "l1": {    //Temporary, will allow user to input point via KU
                _state set ["subPageVarPage", TSD_WPT_DEL_POINTSEL];
            };
        };
    };
    case 3: {   //WPT > DEL point selected
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT]; //TSD_ROOT  TSD_WPT_ROOT  
            };
            case "l4": {    //Do not delete - "No", return to WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
            //case "l3" will delete the selected point
            case "l1": {    //Temporary, will allow user to input point via KU displays the point selected variant
                _state set ["subPageVarPage", TSD_WPT_DEL_POINTSEL];
            };
        };
    };
    case 4: {   //WPT > EDT page
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "l4": {    //Return to WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
            case "l1": {    //Temporary, will allow user to input point via KU, will return you to the WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
        };
    };
    case 5: {   //WPT > EDT page
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "l4": {    //Return to WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
            case "l1": {    //Temporary, will allow user to input point via KU, will return you to the WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
        };
    };
    case 6: {   //WPT > STO page
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "l5": {    //Return to WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
            case "l1": {    //Temporary, will allow user to input point via KU, will return you to the WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
        };
    };
    case 7: {   //WPT > XMIT page
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", TSD_ROOT];
            };
            case "r6": {    //Temporary, will allow user to input point via KU, will return you to the WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
            case "l6": {    //Return to WPT page
                _state set ["subPageVarPage", TSD_WPT];
            };
        };
    };
};