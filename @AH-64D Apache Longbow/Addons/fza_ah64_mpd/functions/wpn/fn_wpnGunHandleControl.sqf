params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

switch (_control) do {
    case "l1": {
        _heli setVariable ["fza_ah64_burst_limit", 10];
    };
    case "l2": {
        _heli setVariable ["fza_ah64_burst_limit", 20];
    };
    case "l3": {
        _heli setVariable ["fza_ah64_burst_limit", 50];
    };
    case "l4": {
        _heli setVariable ["fza_ah64_burst_limit", 100];
    };
    case "l5": {
        _heli setVariable ["fza_ah64_burst_limit", -1];
    };
};