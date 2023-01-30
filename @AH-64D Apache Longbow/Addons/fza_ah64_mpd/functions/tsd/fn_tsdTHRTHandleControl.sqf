#define POINTMODE_THREAT
#include "fn_tsdWPTHandleControl.sqf"

switch (_variant) do {
    case 0: {   //Top level TSD page
        switch (_control) do {
            case "b5": {    //WPT
                _state set ["subPageVarPage", TSD_ROOT];
            };
        };
    };
};