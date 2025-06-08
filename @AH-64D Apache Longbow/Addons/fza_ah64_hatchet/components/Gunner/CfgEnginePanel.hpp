//NVS CONTROLS
CfgSwitch(nvsModeToggle, "nvs_mode_swg", "NVS SWITCH", "cpg_nvsmode", 0.1, ARR_3(1, 0.5, 0), ARR_3(QUOTE(FIXED), QUOTE(NORM), QUOTE(OFF)), [ARR_3(_this#0, QUOTE(nvs), _this#2)] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip3");
//FLOODLIGHTING BUTTON
CfgButtonDown(Floodlighting, cpg_flood, "Flood Light", 0.1, [ARR_3(_this#0, QUOTE(light), QUOTE(FLOODLIGHTING))] call fza_fnc_coreCockpitInteract, "fza_ah64_button_rotary");
//EMERGENCY HYDRAULICS BUTTON
CfgButtonDown(EmergencyHydraulics, "plt_btn_emer_hyd", "Emergency Hydraulics", 0.1, [ARR_3(_this#0, QUOTE(emerHydBtn), QUOTE(emerHyd))] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");