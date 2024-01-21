params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _popOutMenu = _state get "popOutMenu";
private _return   = false;

if (_popOutMenu == 0 && _control != "R3") exitWith {false;};

switch (_control) do {
    case "r1": {
        [_heli, "fza_ah64_hellfireTrajectory", "HI"] call fza_fnc_updateNetworkGlobal;
        _state set ["popOutMenu", 0];
        _return = true;
    };
    case "r2": {
        [_heli, "fza_ah64_hellfireTrajectory", "LO"] call fza_fnc_updateNetworkGlobal;
        _state set ["popOutMenu", 0];
        _return = true;
    };
    case "r3": {
        if (_popOutMenu == 1) then {
        [_heli, "fza_ah64_hellfireTrajectory", "DIR"] call fza_fnc_updateNetworkGlobal;
            _state set ["popOutMenu", 0];
            _return = true;
        } else {
            _state set ["popOutMenu", 1];
            _return = true;
        };
    };
};
_return;