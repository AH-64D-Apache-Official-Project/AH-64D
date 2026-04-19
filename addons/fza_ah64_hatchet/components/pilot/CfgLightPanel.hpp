#pragma hemtt suppress pw3_padded_arg file

CFG_BUTTON_DOWN(Floodlighting, "plt_flood", "$STR_FZA_AH64_TOGGLE_FLOOD_LIGHT", 0.05, [ARR_3(_this#0, 'light', 'FLOODLIGHTING')] call fza_fnc_coreCockpitInteract, "fza_ah64_button_rotary");
CFG_SWITCH(AntiCollision, "plt_anticollision", "$STR_FZA_AH64_TOGGLE_ANTI_COLLISION_LIGHT", "plt_anticollision", 0.05, ARR_2(1, 0), ARR_2("$STR_FZA_AH64_ANTI_COLLISION_ON", "$STR_FZA_AH64_ANTI_COLLISION_OFF"), [ARR_3(_this#0, 'light', _this#2)] call fza_fnc_coreCockpitInteract, [ARR_3(_this#0, 'light', 'anticollisionToggle')] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip3");
