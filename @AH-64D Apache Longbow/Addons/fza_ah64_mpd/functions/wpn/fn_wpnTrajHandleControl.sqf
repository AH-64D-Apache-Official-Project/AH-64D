params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _trajmenu = _state get "trajmenu";
private _return   = false;

switch (_control) do {
    case "r1": {
        _heli setVariable ["fza_ah64_hellfireTrajectory", "HI", true];
        _state set ["trajmenu", 0];
        _return = true;
    };
    case "r2": {
        _heli setVariable ["fza_ah64_hellfireTrajectory", "LO", true];
        _state set ["trajmenu", 0];
        _return = true;
    };
    case "r3": {
        if (_trajmenu == 1) then {
            _heli setVariable ["fza_ah64_hellfireTrajectory", "DIR", true];
            _state set ["trajmenu", 0];
            _return = true;
        } else {
            _state set ["trajmenu", 1];
            _return = true;
        };
    };
};
_return;