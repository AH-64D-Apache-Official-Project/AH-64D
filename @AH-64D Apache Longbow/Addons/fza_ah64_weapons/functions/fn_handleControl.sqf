#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

switch ([_heli, "fza_ah64_was"] call fza_fnc_getSeatVariable) do {
    case WAS_WEAPON_GUN: {
        _heli spawn fza_weapons_fnc_fireCannon;
    };
    case WAS_WEAPON_RKT: {
        _heli spawn fza_weapons_fnc_fireRocket;
    };
    case WAS_WEAPON_MSL: {
        _heli spawn fza_weapons_fnc_fireHellfire;
    };
};