/* fza_ah64_animation – preInit
 * Registers per-category CBA animation settings.
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
    0
] call CBA_fnc_addSetting;

[
    "fza_ah64_animRotor",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_ANIM_ROTOR"), (localize "STR_FZA_AH64_SETTINGS_ANIM_ROTOR_INFO")],
    [_projName, "Animations"],
    [true],
    0
] call CBA_fnc_addSetting;

// The blades or the blur on this machine, for every Apache (fza_anim_fnc_rotorBlades)
if (hasInterface) then {
    fza_anim_rotorHelis = [];
    fza_anim_rotorBladesHandler = addMissionEventHandler ["EachFrame", {
        private _lost = false;
        {
            if (isNull _x) then {_lost = true} else {[_x] call fza_anim_fnc_rotorBlades};
        } forEach fza_anim_rotorHelis;
        if (_lost) then {fza_anim_rotorHelis = fza_anim_rotorHelis select {!isNull _x}};
    }];
};
