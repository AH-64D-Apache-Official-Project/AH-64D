#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex", "_control", "_state"];

private _selectedWeapon = _state get "selectedWeapon";

switch (_selectedWeapon) do {
    case WAS_WEAPON_GUN: {
        _this call fza_mpd_fnc_WpnGunHandleControl;
    };
    case WAS_WEAPON_RKT: {
        _this call fza_mpd_fnc_WpnRktHandleControl;
    };
    case WAS_WEAPON_MSL: {
        _this call fza_mpd_fnc_WpnMslHandleControl;
    };
};

switch (_control) do {
    case "t1": {
        [_heli, _mpdIndex, "chan"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t2": {
        [_heli, _mpdIndex, "ase"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t4": {
        [_heli, _mpdIndex, "code"] call fza_mpd_fnc_setCurrentPage;
    };
    case "r5": {
        if (isNull laserTarget _heli) then {
            [_heli] spawn fza_fnc_laserArm;
        } else {
            [_heli] spawn fza_fnc_laserDisarm;
        };
    };
    case "b2": {
        //Select M230
        if ([_heli, "fza_ah64_was"] call fza_fnc_getSeatVariable == WAS_WEAPON_NONE) then {
            if (_state get "selectedWeapon" != WAS_WEAPON_GUN) then {
                _state set ["selectedWeapon", WAS_WEAPON_GUN];
                _state set ["variant", 0];
            } else {
                _state set ["selectedWeapon", WAS_WEAPON_NONE];
                _state set ["variant", 0];
            }
        };
    };
    case "b3": {
        //Select Missile
        if ([_heli, "fza_ah64_was"] call fza_fnc_getSeatVariable == WAS_WEAPON_NONE) then {
            if (_state get "selectedWeapon" != WAS_WEAPON_MSL) then {
                _state set ["selectedWeapon", WAS_WEAPON_MSL];
                _state set ["variant", 0];
            } else {
                _state set ["selectedWeapon", WAS_WEAPON_NONE];
                _state set ["variant", 0];
            }
        };
    };
    case "b5": {
        if ([_heli, "fza_ah64_was"] call fza_fnc_getSeatVariable == WAS_WEAPON_NONE) then {
            if (_state get "selectedWeapon" != WAS_WEAPON_RKT) then {
                _state set ["selectedWeapon", WAS_WEAPON_RKT];
                _state set ["variant", 0];
            } else {
                _state set ["selectedWeapon", WAS_WEAPON_NONE];
                _state set ["variant", 0];
            }
        };
    };
    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };
};