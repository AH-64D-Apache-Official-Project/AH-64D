CfgSwitch(rotorBrakeToggle, "ctrlref_p_rtrbrake", "Rotor Brake", "plt_rtrbrake", 0.025, ARR_2(0, 1), ARR_2("OFF", "LOCK"), [ARR_3(_this#0, QUOTE(fza_ah64_rtrbrake), _this#3 == 1)] call fza_fnc_animSetValue, "fza_ah64_switch_flip4");
CfgButtonDown(BatteryToggle, "ctrlref_p_mstrign", "Battery Toggle", 0.025, _this#0 call fza_sfmplus_fnc_interactBatterySwitch, "fza_ah64_battery");
CfgButtonDown(ApuToggle, "ctrlref_p_apu", "APU Toggle", 0.025, "_this#0 call fza_sfmplus_fnc_interactApuSwitch", "fza_ah64_apubutton");
CfgButtonDown(EmergencyHydraulics, "plt_btn_emer_hyd", "Emergency Hydraulics", 0.025, [ARR_3(_this#0, QUOTE(emerHydBtn), QUOTE(emerHyd))] call fza_wca_fnc_wcaBtnHandleControl, "fza_ah64_switch_flip4");

//ENGINE ONE CONTROLS
CfgButtonDown(engine1PositionOff,  "ctrlref_p_e1off",   "Engine 1 Off",   0.025, [ARR_3(_this#0, 0, QUOTE(OFF))] call fza_sfmplus_fnc_interactPowerLever,  "fza_ah64_throttle_idle");
CfgButtonDown(engine1PositionIdle, "ctrlref_p_e1idle",  "Engine 1 Idle",  0.025, [ARR_3(_this#0, 0, QUOTE(IDLE))] call fza_sfmplus_fnc_interactPowerLever, "fza_ah64_throttle_idle");
CfgButtonDown(engine1PositionFly,  "ctrlref_p_e1fly",   "Engine 1 Fly",   0.025, [ARR_3(_this#0, 0, QUOTE(FLY))] call fza_sfmplus_fnc_interactPowerLever,  "fza_ah64_fake_3D");
CfgSwitch(engine1StartToggle, "ctrlref_p_e1start", "Engine 1 Start", "plt_eng1_start", 0.025, ARR_3(1, 0.5, 0), ARR_3("START", "OFF", "IGN ORDIE"), [ARR_3(_this#0, 0, _this#2)] call fza_sfmplus_fnc_interactStartSwitch, "fza_ah64_switch_flip4");
//ENGINE TWO CONTROLS
CfgButtonDown(engine2PositionOff,  "ctrlref_p_e2off",   "Engine 2 Off",   0.025, [ARR_3(_this#0, 1, QUOTE(OFF))] call fza_sfmplus_fnc_interactPowerLever,  "fza_ah64_throttle_idle");
CfgButtonDown(engine2PositionIdle, "ctrlref_p_e2idle",  "Engine 2 Idle",  0.025, [ARR_3(_this#0, 1, QUOTE(IDLE))] call fza_sfmplus_fnc_interactPowerLever, "fza_ah64_throttle_idle");
CfgButtonDown(engine2PositionFly,  "ctrlref_p_e2fly",   "Engine 2 Fly",   0.025, [ARR_3(_this#0, 1, QUOTE(FLY))] call fza_sfmplus_fnc_interactPowerLever,  "fza_ah64_fake_3D");
CfgSwitch(engine2StartToggle, "ctrlref_p_e2start", "Engine 2 Start", "plt_eng2_start", 0.025, ARR_3(1, 0.5, 0), ARR_3("START", "OFF", "IGN ORDIE"), [ARR_3(_this#0, 1, _this#2)] call fza_sfmplus_fnc_interactStartSwitch, "fza_ah64_switch_flip4");

//NVS CONTROLS
CfgSwitch(nvsModeToggle, "nvs_mode_sw", "NVS SWITCH", "plt_nvsmode", 0.025, ARR_3(1, 0.5, 0), ARR_3(QUOTE(FIXED), QUOTE(NORM), QUOTE(OFF)), _this#0 setVariable [ARR_2(QUOTE(fza_ah64_ihadss_pnvs_cam), (_this#3))], "fza_ah64_switch_flip3");