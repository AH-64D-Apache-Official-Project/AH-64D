private _cat = ["AH-64D Official Project", "Mission Planner"];

["fza_mplanner_rearmMode", "LIST",
    [(localize "STR_FZA_AH64_MPLANNER_REARM_MODE"), (localize "STR_FZA_AH64_MPLANNER_REARM_MODE_DESC")],
    _cat,
    [[0, 1, 2], ["Instant", "30 Seconds", "ACE Settings"], 1],
    0
] call CBA_fnc_addSetting;

["fza_mplanner_noAmmoSourceRequired", "CHECKBOX",
    [(localize "STR_FZA_AH64_MPLANNER_NO_AMMO_SOURCE_REQUIRED"), (localize "STR_FZA_AH64_MPLANNER_NO_AMMO_SOURCE_REQUIRED_DESC")],
    _cat, true, 0
] call CBA_fnc_addSetting;

["fza_mplanner_noFuelSourceRequired", "CHECKBOX",
    [(localize "STR_FZA_AH64_MPLANNER_NO_FUEL_SOURCE_REQUIRED"), (localize "STR_FZA_AH64_MPLANNER_NO_FUEL_SOURCE_REQUIRED_DESC")],
    _cat, true, 0
] call CBA_fnc_addSetting;

