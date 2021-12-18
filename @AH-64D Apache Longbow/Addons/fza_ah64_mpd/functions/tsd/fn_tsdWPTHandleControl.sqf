params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _phase = BOOLTONUM(_heli getVariable "fza_mpd_tsdMode" == "atk");
private _variant = _state get "subPageVarPage" select 1;

switch (_variant) do {
    case 0: {   //Top level TSD page
        switch (_control) do {
            case "b4": {    //WPT
                _state set ["subPageVarPage", [0, 0]];
            };
            case "l2": {    //WPT > ADD
                _state set ["subPageVarPage", [2, 1]];
            };
            case "l3": {    //WPT > DEL
                _state set ["subPageVarPage", [2, 2]];
            };
        }
    };
    case 1: {   //WPT > ADD
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", [0, 0]];
            };
            case "l2": {    //Return to WPT > ADD
                _state set ["subPageVarPage", [2, 0]];
            };
        }
    };
    case 2: {   //WPT > DEL
        switch (_control) do {
            case "b4": {    //Return to top level TSD (root)
                _state set ["subPageVarPage", [0, 0]];
            };
            case "l3": {    //Do not delete - "No", return to WPT page
                _state set ["subPageVarPage", [2, 0]];
            };
            //case "l2" will delete the selected point
        }
    };
};