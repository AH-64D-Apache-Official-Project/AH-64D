CfgSwitch(rotorBrakeToggle, "ctrlref_p_rtrbrake", "$STR_FZA_AH64_TOGGLE_ROTOR_BRAKE", "plt_rtrbrake", 0.025, ARR_2(0, 1), ARR_2("$STR_FZA_AH64_ROTOR_BRAKE_OFF", "$STR_FZA_AH64_ROTOR_BRAKE_LOCK"), [ARR_3(_this#0, QUOTE(engine), _this#2)] call fza_fnc_coreCockpitInteract, [ARR_3(_this#0, QUOTE(engine), QUOTE(rtrbraketoggle))] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");

CfgButtonDown(BatteryToggle, "ctrlref_p_mstrign", "$STR_FZA_AH64_TOGGLE_BATTERY_POWER", 0.025, [ARR_3(_this#0, QUOTE(engine), QUOTE(power))] call fza_fnc_coreCockpitInteract, "fza_ah64_battery");
CfgButtonDown(ApuToggle, "ctrlref_p_apu", "$STR_FZA_AH64_TOGGLE_APU_POWER", 0.025, [ARR_3(_this#0, QUOTE(engine), QUOTE(apu))] call fza_fnc_coreCockpitInteract, "fza_ah64_apubutton");
CfgButtonDown(EmergencyHydraulics, "plt_btn_emer_hyd", "$STR_FZA_AH64_TOGGLE_EMERGENCY_HYDRAULICS", 0.025, [ARR_3(_this#0, QUOTE(emerHydBtn), QUOTE(emerHyd))] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");

//ENGINE ONE CONTROLS
CfgButtonDown(engine1PositionOff,  "ctrlref_p_e1off",   "$STR_FZA_AH64_SET_ENGINE_1_OFF",   0.025, [ARR_3(_this#0, QUOTE(engine), QUOTE(e1off))] call fza_fnc_coreCockpitInteract,  "fza_ah64_throttle_idle");
CfgButtonDown(engine1PositionIdle, "ctrlref_p_e1idle",  "$STR_FZA_AH64_SET_ENGINE_1_IDLE",  0.025, [ARR_3(_this#0, QUOTE(engine), QUOTE(e1idle))] call fza_fnc_coreCockpitInteract, "fza_ah64_throttle_idle");
CfgButtonDown(engine1PositionFly,  "ctrlref_p_e1fly",   "$STR_FZA_AH64_SET_ENGINE_1_FLY",   0.025, [ARR_3(_this#0, QUOTE(engine), QUOTE(e1fly))] call fza_fnc_coreCockpitInteract,  "fza_ah64_fake_3D");
CfgSwitch(engine1StartToggle, "ctrlref_p_e1start", "$STR_FZA_AH64_START_OVERRIDE_ENGINE_1", "plt_eng1_start", 0.025, ARR_3(1, 0.5, 0), ARR_3("$STR_FZA_AH64_ENGINE_ONE_START", "$STR_FZA_AH64_ENGINE_ONE_OFF", "$STR_FZA_AH64_ENGINE_ONE_IGN_OVERRIDE"), [ARR_3(_this#0, QUOTE(engine), _this#2)] call fza_fnc_coreCockpitInteract, [ARR_3(_this#0, QUOTE(engine), QUOTE(e1startertoggle))] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");
//ENGINE TWO CONTROLS
CfgButtonDown(engine2PositionOff,  "ctrlref_p_e2off",   "$STR_FZA_AH64_SET_ENGINE_2_OFF",   0.025, [ARR_3(_this#0, QUOTE(engine), QUOTE(e2off))] call fza_fnc_coreCockpitInteract,  "fza_ah64_throttle_idle");
CfgButtonDown(engine2PositionIdle, "ctrlref_p_e2idle",  "$STR_FZA_AH64_SET_ENGINE_2_IDLE",  0.025, [ARR_3(_this#0, QUOTE(engine), QUOTE(e2idle))] call fza_fnc_coreCockpitInteract, "fza_ah64_throttle_idle");
CfgButtonDown(engine2PositionFly,  "ctrlref_p_e2fly",   "$STR_FZA_AH64_SET_ENGINE_2_FLY",   0.025, [ARR_3(_this#0, QUOTE(engine), QUOTE(e2fly))] call fza_fnc_coreCockpitInteract,  "fza_ah64_fake_3D");
CfgSwitch(engine2StartToggle, "ctrlref_p_e2start", "$STR_FZA_AH64_START_OVERRIDE_ENGINE_2", "plt_eng2_start", 0.025, ARR_3(1, 0.5, 0), ARR_3("$STR_FZA_AH64_ENGINE_TWO_START", "$STR_FZA_AH64_ENGINE_TWO_OFF", "$STR_FZA_AH64_ENGINE_TWO_IGN_OVERRIDE"), [ARR_3(_this#0, QUOTE(engine), _this#2)] call fza_fnc_coreCockpitInteract, [ARR_3(_this#0, QUOTE(engine), QUOTE(e2startertoggle))] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");

//NVS CONTROLS
CfgSwitch(nvsModeToggle, "nvs_mode_sw", "$STR_FZA_AH64_TOGGLE_NIGHT_VISION_SYSTEM", "plt_nvsmode", 0.025, ARR_3(1, 0.5, 0), ARR_3(QUOTE(FIXED), QUOTE(NORM), QUOTE(OFF)), [ARR_3(_this#0, QUOTE(nvs), _this#2)] call fza_fnc_coreCockpitInteract, [ARR_3(_this#0, QUOTE(nvs), QUOTE(nvsSwitchToggle))] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip3");