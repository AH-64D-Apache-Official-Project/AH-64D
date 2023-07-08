params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _Trajmenu = _state get "Trajmenu";

switch (_control) do {
    case "r1": {
        _heli setVariable ["fza_ah64_hellfireTrajectory", "HI", true];
        _state set ["Trajmenu", 0]
    };
    case "r2": {
        _heli setVariable ["fza_ah64_hellfireTrajectory", "LO", true];
        _state set ["Trajmenu", 0]
    };
    case "r3": {
        if (_Trajmenu == 1) then {
            _heli setVariable ["fza_ah64_hellfireTrajectory", "DIR", true];
            _state set ["Trajmenu", 0]
        } else {
            _state set ["Trajmenu", 1]
        };
    };
};