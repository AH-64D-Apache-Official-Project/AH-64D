//NVS CONTROLS
CfgSwitch(nvsModeToggle, "nvs_mode_swg", "$STR_FZA_AH64_TOGGLE_NIGHT_VISION_SYSTEM", "cpg_nvsmode", 0.1, ARR_3(1, 0.5, 0), ARR_3("$STR_FZA_AH64_NVS_FIXED", "$STR_FZA_AH64_NVS_NORM", "$STR_FZA_AH64_NVS_OFF"), [ARR_3(_this#0, QUOTE(nvs), _this#2)] call fza_fnc_coreCockpitInteract, [ARR_3(_this#0, QUOTE(nvs), QUOTE(nvsSwitchToggle))] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip3");
//EMERGENCY HYDRAULICS BUTTON
CfgButtonDown(EmergencyHydraulics, "plt_btn_emer_hyd", "$STR_FZA_AH64_TOGGLE_EMERGENCY_HYDRAULICS", 0.1, [ARR_3(_this#0, QUOTE(emerHydBtn), QUOTE(emerHyd))] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");
