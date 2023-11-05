params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _quantityMenu   = _state get "popOutMenu";
private _controlHandled = false;

if (_quantityMenu == 0 && _control != "r1") exitWith {false;};

switch (_control) do {
    case "r1": {
        if (_quantityMenu == 1) then {
            [_heli, "fza_ah64_rocketsalvo", 1] call fza_fnc_updateNetworkGlobal;
            _state set ["popOutMenu", 0];
            _controlHandled = true;
        } else {
            _state set ["popOutMenu", 1];
            _controlHandled = true;
        };
    };
    case "r2": {
        [_heli, "fza_ah64_rocketsalvo", 2] call fza_fnc_updateNetworkGlobal;
        _state set ["popOutMenu", 0];
        _controlHandled = true;
    };
    case "r3": {
        [_heli, "fza_ah64_rocketsalvo", 4] call fza_fnc_updateNetworkGlobal;
        _state set ["popOutMenu", 0];
        _controlHandled = true;
    };
    case "r4": {
        [_heli, "fza_ah64_rocketsalvo", 8] call fza_fnc_updateNetworkGlobal;
        _state set ["popOutMenu", 0];
        _controlHandled = true;
    };
    case "r5": {
        [_heli, "fza_ah64_rocketsalvo", 12] call fza_fnc_updateNetworkGlobal;
        _state set ["popOutMenu", 0];
        _controlHandled = true;
    };
    case "r6": {
        [_heli, "fza_ah64_rocketsalvo", 24] call fza_fnc_updateNetworkGlobal;
        _state set ["popOutMenu", 0];
        _controlHandled = true;
    };
    case "b6": {
        [_heli, "fza_ah64_rocketsalvo", 99] call fza_fnc_updateNetworkGlobal;
        _state set ["popOutMenu", 0];
        _controlHandled = true;
    };
};
_controlHandled;