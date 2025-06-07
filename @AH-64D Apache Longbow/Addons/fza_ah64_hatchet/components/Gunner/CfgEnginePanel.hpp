//NVS CONTROLS
CfgSwitch(nvsModeToggle, "nvs_mode_swg", "NVS SWITCH", "cpg_nvsmode", 0.1, ARR_3(1, 0.5, 0), ARR_3(QUOTE(FIXED), QUOTE(NORM), QUOTE(OFF)), _this#0 setVariable [ARR_2(QUOTE(fza_ah64_ihadss_pnvs_cam), (_this#3))], "fza_ah64_switch_flip3");
//FLOODLIGHTING CONTROLS
CfgButtonDown(Floodlighting, cpg_flood, "Flood Light", 0.1, [ARR_3(_this#0, QUOTE(light), QUOTE(FLOODLIGHTING))] call fza_light_fnc_handleControl, "fza_ah64_button_rotary");