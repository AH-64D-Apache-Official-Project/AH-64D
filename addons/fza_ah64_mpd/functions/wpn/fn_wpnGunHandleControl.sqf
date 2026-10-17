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
    case "r2": {
        // Gun MODE, in each crew station: NORM follows the selected sight, FXD fixes the gun to the aircraft centerline
        private _gunMode = [_heli, "fza_ah64_gunMode"] call fza_fnc_getSeatVariable;
        [_heli, "fza_ah64_gunMode", ["FXD", "NORM"] select (!isNil "_gunMode" && {_gunMode == "FXD"})] call fza_fnc_setSeatVariable;
    };
};
