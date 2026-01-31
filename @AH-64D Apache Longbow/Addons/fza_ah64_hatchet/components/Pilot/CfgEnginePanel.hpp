CfgSwitch(rotorBrakeToggle, "ctrlref_p_rtrbrake", "Rotor Brake", "plt_rtrbrake", 0.025, ARR_2(0, 1), ARR_2("ROTOR BRAKE OFF", "ROTOR BRAKE LOCK"), [ARR_3(_this#0, QUOTE(engine), _this#2)] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");

CfgButtonDown(BatteryToggle, "ctrlref_p_mstrign", "Battery Toggle", 0.025, [ARR_3(_this#0, QUOTE(engine), QUOTE(power))] call fza_fnc_coreCockpitInteract, "fza_ah64_battery");
CfgButtonDown(ApuToggle, "ctrlref_p_apu", "APU Toggle", 0.025, [ARR_3(_this#0, QUOTE(engine), QUOTE(apu))] call fza_fnc_coreCockpitInteract, "fza_ah64_apubutton");
CfgButtonDown(EmergencyHydraulics, "plt_btn_emer_hyd", "Emergency Hydraulics", 0.025, [ARR_3(_this#0, QUOTE(emerHydBtn), QUOTE(emerHyd))] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");

//ENGINE ONE CONTROLS
CfgButtonDown(engine1PositionOff,  "ctrlref_p_e1off",   "Engine 1 Off",   0.025, [ARR_3(_this#0, QUOTE(engine), QUOTE(e1off))] call fza_fnc_coreCockpitInteract,  "fza_ah64_throttle_idle");
CfgButtonDown(engine1PositionIdle, "ctrlref_p_e1idle",  "Engine 1 Idle",  0.025, [ARR_3(_this#0, QUOTE(engine), QUOTE(e1idle))] call fza_fnc_coreCockpitInteract, "fza_ah64_throttle_idle");
CfgButtonDown(engine1PositionFly,  "ctrlref_p_e1fly",   "Engine 1 Fly",   0.025, [ARR_3(_this#0, QUOTE(engine), QUOTE(e1fly))] call fza_fnc_coreCockpitInteract,  "fza_ah64_fake_3D");
CfgSwitch(engine1StartToggle, "ctrlref_p_e1start", "Engine 1 Start", "plt_eng1_start", 0.025, ARR_3(1, 0.5, 0), ARR_3("ENGINE ONE START", "OFF", "ENGINE ONE IGN ORDIE"), [ARR_3(_this#0, QUOTE(engine), _this#2)] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");
//ENGINE TWO CONTROLS
CfgButtonDown(engine2PositionOff,  "ctrlref_p_e2off",   "Engine 2 Off",   0.025, [ARR_3(_this#0, QUOTE(engine), QUOTE(e2off))] call fza_fnc_coreCockpitInteract,  "fza_ah64_throttle_idle");
CfgButtonDown(engine2PositionIdle, "ctrlref_p_e2idle",  "Engine 2 Idle",  0.025, [ARR_3(_this#0, QUOTE(engine), QUOTE(e2idle))] call fza_fnc_coreCockpitInteract, "fza_ah64_throttle_idle");
CfgButtonDown(engine2PositionFly,  "ctrlref_p_e2fly",   "Engine 2 Fly",   0.025, [ARR_3(_this#0, QUOTE(engine), QUOTE(e2fly))] call fza_fnc_coreCockpitInteract,  "fza_ah64_fake_3D");
CfgSwitch(engine2StartToggle, "ctrlref_p_e2start", "Engine 2 Start", "plt_eng2_start", 0.025, ARR_3(1, 0.5, 0), ARR_3("ENGINE TWO START", "OFF", "ENGINE TWO IGN ORDIE"), [ARR_3(_this#0, QUOTE(engine), _this#2)] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");

//NVS CONTROLS
CfgSwitch(nvsModeToggle, "nvs_mode_sw", "NVS SWITCH", "plt_nvsmode", 0.025, ARR_3(1, 0.5, 0), ARR_3(QUOTE(FIXED), QUOTE(NORM), QUOTE(OFF)), [ARR_3(_this#0, QUOTE(nvs), _this#2)] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip3");