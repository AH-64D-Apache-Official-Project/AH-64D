#pragma hemtt suppress pw3_padded_arg file

CFG_SWITCH(rotorBrakeToggle, "ctrlref_p_rtrbrake", "$STR_FZA_AH64_TOGGLE_ROTOR_BRAKE", "plt_rtrbrake", 0.025, ARR_2(0, 1), ARR_2("$STR_FZA_AH64_ROTOR_BRAKE_OFF", "$STR_FZA_AH64_ROTOR_BRAKE_LOCK"), [ARR_3(_this#0, 'engine', _this#2)] call fza_fnc_coreCockpitInteract, [ARR_3(_this#0, 'engine', 'rtrbraketoggle')] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");

CFG_BUTTON_DOWN(BatteryToggle, "ctrlref_p_mstrign", "$STR_FZA_AH64_TOGGLE_BATTERY_POWER", 0.025, [ARR_3(_this#0, 'engine', 'power')] call fza_fnc_coreCockpitInteract, "fza_ah64_battery");
CFG_BUTTON_DOWN(ApuToggle, "ctrlref_p_apu", "$STR_FZA_AH64_TOGGLE_APU_POWER", 0.025, [ARR_3(_this#0, 'engine', 'apu')] call fza_fnc_coreCockpitInteract, "fza_ah64_apubutton");
CFG_BUTTON_DOWN(EmergencyHydraulics, "plt_btn_emer_hyd", "$STR_FZA_AH64_TOGGLE_EMERGENCY_HYDRAULICS", 0.025, [ARR_3(_this#0, 'emerHydBtn', 'emerHyd')] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");

//ENGINE ONE CONTROLS
CFG_BUTTON_DOWN(engine1PositionOff,  "ctrlref_p_e1off",   "$STR_FZA_AH64_SET_ENGINE_1_OFF",   0.025, [ARR_3(_this#0, 'engine', 'e1off')] call fza_fnc_coreCockpitInteract,  "fza_ah64_throttle_idle");
CFG_BUTTON_DOWN(engine1PositionIdle, "ctrlref_p_e1idle",  "$STR_FZA_AH64_SET_ENGINE_1_IDLE",  0.025, [ARR_3(_this#0, 'engine', 'e1idle')] call fza_fnc_coreCockpitInteract, "fza_ah64_throttle_idle");
CFG_BUTTON_DOWN(engine1PositionFly,  "ctrlref_p_e1fly",   "$STR_FZA_AH64_SET_ENGINE_1_FLY",   0.025, [ARR_3(_this#0, 'engine', 'e1fly')] call fza_fnc_coreCockpitInteract,  "fza_ah64_fake_3D");
CFG_SWITCH(engine1StartToggle, "ctrlref_p_e1start", "$STR_FZA_AH64_START_OVERRIDE_ENGINE_1", "plt_eng1_start", 0.025, ARR_3(1, 0.5, 0), ARR_3("$STR_FZA_AH64_ENGINE_ONE_START", "$STR_FZA_AH64_ENGINE_ONE_OFF", "$STR_FZA_AH64_ENGINE_ONE_IGN_OVERRIDE"), [ARR_3(_this#0, 'engine', _this#2)] call fza_fnc_coreCockpitInteract, [ARR_3(_this#0, 'engine', 'e1startertoggle')] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");
//ENGINE TWO CONTROLS
CFG_BUTTON_DOWN(engine2PositionOff,  "ctrlref_p_e2off",   "$STR_FZA_AH64_SET_ENGINE_2_OFF",   0.025, [ARR_3(_this#0, 'engine', 'e2off')] call fza_fnc_coreCockpitInteract,  "fza_ah64_throttle_idle");
CFG_BUTTON_DOWN(engine2PositionIdle, "ctrlref_p_e2idle",  "$STR_FZA_AH64_SET_ENGINE_2_IDLE",  0.025, [ARR_3(_this#0, 'engine', 'e2idle')] call fza_fnc_coreCockpitInteract, "fza_ah64_throttle_idle");
CFG_BUTTON_DOWN(engine2PositionFly,  "ctrlref_p_e2fly",   "$STR_FZA_AH64_SET_ENGINE_2_FLY",   0.025, [ARR_3(_this#0, 'engine', 'e2fly')] call fza_fnc_coreCockpitInteract,  "fza_ah64_fake_3D");
CFG_SWITCH(engine2StartToggle, "ctrlref_p_e2start", "$STR_FZA_AH64_START_OVERRIDE_ENGINE_2", "plt_eng2_start", 0.025, ARR_3(1, 0.5, 0), ARR_3("$STR_FZA_AH64_ENGINE_TWO_START", "$STR_FZA_AH64_ENGINE_TWO_OFF", "$STR_FZA_AH64_ENGINE_TWO_IGN_OVERRIDE"), [ARR_3(_this#0, 'engine', _this#2)] call fza_fnc_coreCockpitInteract, [ARR_3(_this#0, 'engine', 'e2startertoggle')] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");

//NVS CONTROLS
CFG_SWITCH(nvsModeToggle, "nvs_mode_sw", "$STR_FZA_AH64_TOGGLE_NIGHT_VISION_SYSTEM", "plt_nvsmode", 0.025, ARR_3(1, 0.5, 0), ARR_3("$STR_FZA_AH64_NVS_FIXED", "$STR_FZA_AH64_NVS_NORM", "$STR_FZA_AH64_NVS_OFF"), [ARR_3(_this#0, 'nvs', _this#2)] call fza_fnc_coreCockpitInteract, [ARR_3(_this#0, 'nvs', 'nvsSwitchToggle')] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip3");
