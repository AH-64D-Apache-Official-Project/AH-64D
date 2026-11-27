private _cat = ["AH-64D Official Project", "Mission Planner"];

// Server settings: the server's values apply to every player
["fza_mplanner_rearmMode", "LIST",
    [(localize "STR_FZA_AH64_MPLANNER_REARM_MODE"), (localize "STR_FZA_AH64_MPLANNER_REARM_MODE_DESC")],
    _cat,
    [[0, 1, 2], ["Instant", "30 Seconds", "Per Item"], 1],
    1
] call CBA_fnc_addSetting;

["fza_mplanner_noAmmoSourceRequired", "CHECKBOX",
    [(localize "STR_FZA_AH64_MPLANNER_NO_AMMO_SOURCE_REQUIRED"), (localize "STR_FZA_AH64_MPLANNER_NO_AMMO_SOURCE_REQUIRED_DESC")],
    _cat, true, 1
] call CBA_fnc_addSetting;

["fza_mplanner_noFuelSourceRequired", "CHECKBOX",
    [(localize "STR_FZA_AH64_MPLANNER_NO_FUEL_SOURCE_REQUIRED"), (localize "STR_FZA_AH64_MPLANNER_NO_FUEL_SOURCE_REQUIRED_DESC")],
    _cat, true, 1
] call CBA_fnc_addSetting;

["fza_mplanner_sourceDistance", "SLIDER",
    [(localize "STR_FZA_AH64_MPLANNER_SOURCE_DISTANCE"), (localize "STR_FZA_AH64_MPLANNER_SOURCE_DISTANCE_DESC")],
    _cat, [5, 50, 25, 0], 1
] call CBA_fnc_addSetting;

["fza_mplanner_fuelRate", "SLIDER",
    [(localize "STR_FZA_AH64_MPLANNER_FUEL_RATE"), (localize "STR_FZA_AH64_MPLANNER_FUEL_RATE_DESC")],
    _cat, [1, 50, 8, 0], 1
] call CBA_fnc_addSetting;

// The planner can be used from outside the aircraft, so everything that changes it runs where it is local

// Fuel as a mass, made a share of the tanks fitted here, where the pylon and IAFS changes are already in.
// _done < 1 is a stopped step: that share of the way from the fuel aboard.
["fza_mplanner_setFuel", {
    params ["_heli", "_kg", ["_done", 1]];
    private _cap = [_heli] call fza_ah64_helisim_fnc_fuelCapacity;
    if (_cap <= 0) exitWith {};
    private _from = (fuel _heli) * _cap;
    private _to = (_kg min _cap) max 0;
    _heli setFuel (((_from + (_to - _from) * _done) / _cap) max 0 min 1);
    [_heli] call bmkhs_fnc_fuelSet;
}] call CBA_fnc_addEventHandler;

["fza_mplanner_setGunAmmo", {
    params ["_heli", "_rounds"];
    _heli setAmmo ["fza_m230", _rounds];
}] call CBA_fnc_addEventHandler;

// The magazine_set_1200 animation swaps the magazine (onPhaseChanged), so its phase stays with the magazine fitted;
// an animation already at that phase won't fire, so then the swap is made here
["fza_mplanner_swapGunMag", {
    params ["_heli", "_phase"];
    if (abs ((_heli animationSourcePhase "magazine_set_1200") - _phase) < 0.01) then {
        [_heli, _phase] call fza_fnc_weaponSwapM230Mag;
    } else {
        _heli animateSource ["magazine_set_1200", _phase, true];
    };
}] call CBA_fnc_addEventHandler;

// On the gunner's turret, as fza_fnc_weaponPylonCheckValid expects; a pylon weapon no magazine uses any more is removed
["fza_mplanner_setPylon", {
    params ["_heli", "_pylon", "_magazine", "_count"];
    private _oldWeapon = getText (configFile >> "CfgMagazines" >> ((getPylonMagazines _heli) param [_pylon - 1, ""]) >> "pylonWeapon");
    _heli setPylonLoadout [_pylon, _magazine, false, [0]];
    if (_magazine != "") then {_heli setAmmoOnPylon [_pylon, _count]};
    if (_oldWeapon == "" || {(getPylonMagazines _heli) findIf {getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon") == _oldWeapon} != -1}) exitWith {};
    {
        ["fza_mplanner_removeWeapon", [_heli, _oldWeapon, _x], _heli, _x] call CBA_fnc_turretEvent;
    } forEach [[-1], [0]];
}] call CBA_fnc_addEventHandler;

["fza_mplanner_removeWeapon", {
    params ["_heli", "_weapon", "_turret"];
    _heli removeWeaponTurret [_weapon, _turret];
}] call CBA_fnc_addEventHandler;

["fza_mplanner_animate", {
    params ["_heli", "_source", "_phase", ["_instant", false]];
    _heli animateSource [_source, _phase, _instant];
}] call CBA_fnc_addEventHandler;

// Sent after every change, so it runs once they have all been made
["fza_mplanner_finish", {
    params ["_heli", ["_restock", true]];
    _heli setVariable ["fza_mplanner_rearming", false];
    [_heli] call fza_fnc_weaponPylonCheckValid;
    [_heli] call bmkhs_fnc_massUpdate;
    if (_restock) then {[_heli] call fza_ase_fnc_restock};
}] call CBA_fnc_addEventHandler;
