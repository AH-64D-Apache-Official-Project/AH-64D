params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _quantityMenu = _state get "popOutMenu";
private _return       = false;

if (_quantityMenu == 0 && _control != "r1") exitWith {false;};

switch (_control) do {
    case "r1": {
        if (_quantityMenu == 1) then {
            _heli setVariable ["fza_ah64_rocketsalvo", 1, true];
            _state set ["popOutMenu", 0];
            _return = true;
        } else {
            _state set ["popOutMenu", 1];
            _return = true;
        };
    };
    case "r2": {
        _heli setVariable ["fza_ah64_rocketsalvo", 2, true];
        _state set ["popOutMenu", 0];
        _return = true;
    };
    case "r3": {
        _heli setVariable ["fza_ah64_rocketsalvo", 4, true];
        _state set ["popOutMenu", 0];
        _return = true;
    };
    case "r4": {
        _heli setVariable ["fza_ah64_rocketsalvo", 8, true];
        _state set ["popOutMenu", 0];
        _return = true;
    };
    case "r5": {
        _heli setVariable ["fza_ah64_rocketsalvo", 12, true];
        _state set ["popOutMenu", 0];
        _return = true;
    };
    case "r6": {
        _heli setVariable ["fza_ah64_rocketsalvo", 24, true];
        _state set ["popOutMenu", 0];
        _return = true;
    };
    case "b6": {
        _heli setVariable ["fza_ah64_rocketsalvo", 99, true];
        _state set ["popOutMenu", 0];
        _return = true;
    };
};
_return;