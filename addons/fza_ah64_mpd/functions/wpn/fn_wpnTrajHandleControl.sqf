params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _popOutMenu = _state get "popOutMenu";
private _return   = false;

// Only with its own pop-out open (1), or TRAJ pressed to open it; not under the MODE pop-out (2)
if (_popOutMenu != 1 && {_popOutMenu != 0 || _control != "R3"}) exitWith {false;};

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
