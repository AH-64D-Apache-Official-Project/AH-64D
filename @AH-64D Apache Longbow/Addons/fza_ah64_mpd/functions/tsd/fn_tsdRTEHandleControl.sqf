params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"

switch (_control) do {
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