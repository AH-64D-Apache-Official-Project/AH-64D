params ["_heli", "_mpdIndex", "_control", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

if (_this call fza_mpd_fnc_wpnQuantityHandleControl) exitwith {};

switch (_control) do {
    case "l1": {
        [_heli, 0] call fza_weapons_fnc_RocketSetSelected;
    };
    case "l2": {
        [_heli, 1] call fza_weapons_fnc_RocketSetSelected;
    };
    case "l3": {
        [_heli, 2] call fza_weapons_fnc_RocketSetSelected;
    };
    case "l4": {
        [_heli, 3] call fza_weapons_fnc_RocketSetSelected;
    };
    case "l5": {
        [_heli, 4] call fza_weapons_fnc_RocketSetSelected;
    };
};