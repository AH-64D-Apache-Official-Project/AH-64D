#pragma hemtt suppress pw3_padded_arg file

CFG_BUTTON_DOWN(FirePanelEngineOne,     "ctrlref_p_fe1",  "$STR_FZA_AH64_SELECT_ENGINE_1",       0.025, [ARR_3(_this#0, 'fire', 'fe1')] call fza_fnc_coreCockpitInteract,  "fza_ah64_button_click2");
CFG_BUTTON_DOWN(FirePanelAPU,           "ctrlref_p_fapu", "$STR_FZA_AH64_SELECT_APU",            0.025, [ARR_3(_this#0, 'fire', 'fapu')] call fza_fnc_coreCockpitInteract, "fza_ah64_button_click2");
CFG_BUTTON_DOWN(FirePanelEngineTwo,     "ctrlref_p_fe2",  "$STR_FZA_AH64_SELECT_ENGINE_2",       0.025, [ARR_3(_this#0, 'fire', 'fe2')] call fza_fnc_coreCockpitInteract,  "fza_ah64_button_click2");
CFG_BUTTON_DOWN(FirePanelBottlePrimary, "ctrlref_p_fbp",  "$STR_FZA_AH64_DISCHARGE_PRIMARY_FIRE_BOTTLE", 0.025, [ARR_3(_this#0, 'fire', 'fbp')] call fza_fnc_coreCockpitInteract,  "fza_ah64_button_click2");
CFG_BUTTON_DOWN(FirePanelBottleReserve, "ctrlref_p_fbr",  "$STR_FZA_AH64_DISCHARGE_RESERVE_FIRE_BOTTLE", 0.025, [ARR_3(_this#0, 'fire', 'fbr')] call fza_fnc_coreCockpitInteract,  "fza_ah64_button_click2");

CFG_SWITCH(FirePanelTestSwitch, "ctrlref_p_swfiretst", "$STR_FZA_AH64_TEST_FIRE_SYSTEM", "plt_firesw", 0.025, ARR_3(1, 0.5, 0), ARR_3("$STR_FZA_AH64_FIRE_TEST_1", "$STR_FZA_AH64_FIRE_TEST_OFF", "$STR_FZA_AH64_FIRE_TEST_2"), [ARR_3(_this#0, 'fire', _this#2)] call fza_fnc_coreCockpitInteract, [ARR_3(_this#0, 'fire', 'fireTestToggle')] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");
