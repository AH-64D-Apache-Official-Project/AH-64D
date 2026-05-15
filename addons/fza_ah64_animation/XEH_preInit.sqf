/* fza_ah64_animation – preInit
 * Registers CBA settings and hooks the per-frame animation dispatcher.
 */
private _projName = "AH-64D Official Project";

// ── CBA settings ─────────────────────────────────────────────────────────────
[
    "fza_ah64_animControls",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_ANIM_CONTROLS"), (localize "STR_FZA_AH64_SETTINGS_ANIM_CONTROLS_INFO")],
    [_projName, "Animations"],
    [true],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_animProbes",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_ANIM_PROBES"), (localize "STR_FZA_AH64_SETTINGS_ANIM_PROBES_INFO")],
    [_projName, "Animations"],
    [true],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_animRotor",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_ANIM_ROTOR"), (localize "STR_FZA_AH64_SETTINGS_ANIM_ROTOR_INFO")],
    [_projName, "Animations"],
    [true],
    2
] call CBA_fnc_addSetting;


