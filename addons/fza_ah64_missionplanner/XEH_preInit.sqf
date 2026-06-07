private _cat = ["AH-64D Official Project", "Mission Planner"];

["fza_mplanner_instantApply", "CHECKBOX",
    [(localize "STR_FZA_AH64_MPLANNER_INSTANT_APPLY"), (localize "STR_FZA_AH64_MPLANNER_INSTANT_APPLY_DESC")],
    _cat, true, 0
] call CBA_fnc_addSetting;

["fza_mplanner_ammoLimitEnable", "CHECKBOX",
    [(localize "STR_FZA_AH64_MPLANNER_AMMO_LIMIT_ENABLE"), (localize "STR_FZA_AH64_MPLANNER_AMMO_LIMIT_ENABLE_DESC")],
    _cat, false, 0
] call CBA_fnc_addSetting;

{
    private _key = _x # 0;
    private _str = _x # 1;
    private _max = [999, 12000] select (_key == "M230");
    [("fza_mplanner_ammo_" + _key), "SLIDER",
        [(localize _str), (localize "STR_FZA_AH64_MPLANNER_AMMO_DESC")],
        _cat, [-1, _max, -1, 0], 0
    ] call CBA_fnc_addSetting;
} forEach [
    ["AGM114K",   "STR_FZA_AH64_MPLANNER_AMMO_AGM114K"],
    ["AGM114L",   "STR_FZA_AH64_MPLANNER_AMMO_AGM114L"],
    ["AGM114K2A", "STR_FZA_AH64_MPLANNER_AMMO_AGM114K2A"],
    ["AGM114FA",  "STR_FZA_AH64_MPLANNER_AMMO_AGM114FA"],
    ["AGM114N",   "STR_FZA_AH64_MPLANNER_AMMO_AGM114N"],
    ["M151",      "STR_FZA_AH64_MPLANNER_AMMO_M151"],
    ["M261",      "STR_FZA_AH64_MPLANNER_AMMO_M261"],
    ["M255A1",    "STR_FZA_AH64_MPLANNER_AMMO_M255A1"],
    ["M257",      "STR_FZA_AH64_MPLANNER_AMMO_M257"],
    ["M278",      "STR_FZA_AH64_MPLANNER_AMMO_M278"],
    ["M230",      "STR_FZA_AH64_MPLANNER_AMMO_M230"]
];

