//PILOT FIRE PANEL
CfgButtonDown(FirePanelEngineOne,     "ctrlref_p_fe1",  "Fire Engine 1",       0.025, [ARR_3(_this#0, QUOTE(fire), QUOTE(fe1))] call fza_fire_fnc_handleControl,  "fza_ah64_button_click2");
CfgButtonDown(FirePanelAPU,           "ctrlref_p_fapu", "Fire APU",            0.025, [ARR_3(_this#0, QUOTE(fire), QUOTE(fapu))] call fza_fire_fnc_handleControl, "fza_ah64_button_click2");
CfgButtonDown(FirePanelEngineTwo,     "ctrlref_p_fe2",  "Fire Engine 2",       0.025, [ARR_3(_this#0, QUOTE(fire), QUOTE(fe2))] call fza_fire_fnc_handleControl,  "fza_ah64_button_click2");
CfgButtonDown(FirePanelBottlePrimary, "ctrlref_p_fbp",  "Fire Bottle Primary", 0.025, [ARR_3(_this#0, QUOTE(fire), QUOTE(fbp))] call fza_fire_fnc_handleControl,  "fza_ah64_button_click2");
CfgButtonDown(FirePanelBottleReserve, "ctrlref_p_fbr",  "Fire Bottle Reserve", 0.025, [ARR_3(_this#0, QUOTE(fire), QUOTE(fbr))] call fza_fire_fnc_handleControl,  "fza_ah64_button_click2");

CfgSwitch(FirePanelTestSwitch, ctrlref_p_swfiretst, "FIRE TEST", "plt_firesw", 0.025, ARR_3(0, 0.5, 1), ARR_3("FIRE TEST 1", "OFF", "FIRE TEST 2"), [ARR_3(_this#0, QUOTE(fire), _this#3)] call fza_fire_fnc_handleControl, "fza_ah64_switch_flip4");