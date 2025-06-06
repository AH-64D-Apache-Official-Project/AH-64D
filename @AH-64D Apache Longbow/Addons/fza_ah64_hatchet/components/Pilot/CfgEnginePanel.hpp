

//CfgStaticButtonDown(BatteryToggle, "ctrlref_p_mstrign", "Battery Toggle", 0.025, _this#0 call fza_sfmplus_fnc_interactBatterySwitch;, "fza_ah64_battery");

//CfgTwoStateSwitch(rotorBrakeToggle, "ctrlref_p_rtrbrake", "Rotor Brake", "plt_rtrbrake", 0, 1, "OFF", "LOCK", 0.025, "[_this#0, "fza_ah64_rtrbrake", (_this#3 == 1)] call fza_fnc_animSetValue;", "fza_ah64_switch_flip4");


class rotorBrakeToggle {
    positionType = "anim";
    position = "ctrlref_p_rtrbrake";
    label = "Rotor Brake";
    animation = "plt_rtrbrake";
    animStates[] = {0, 1};
    animLabels[] = {"OFF", "LOCK"};
    radius = 0.025;
    animend = "[_this#0, ""fza_ah64_rtrbrake"", (_this#3 == 1)] call fza_fnc_animSetValue;";
};
class BatteryToggle {
    positionType = "static";
    position = "ctrlref_p_mstrign";
    label = "Battery Toggle";
    radius = 0.025;
    buttonDown = "_this#0 call fza_sfmplus_fnc_interactBatterySwitch;";
    clickSound = "fza_ah64_battery";
};
class ApuToggle {
    positionType = "static";
    position = "ctrlref_p_apu";
    label = "APU Toggle";
    radius = 0.025
    buttonDown = "_this#0 call fza_sfmplus_fnc_interactApuSwitch;";
    clickSound = "fza_ah64_apubutton";
};
class engine1StartToggle {
    positionType = "anim";
    position = "ctrlref_p_e1start";
    label = "Engine 1 Start";
    animation = "plt_eng1_start";
    animStates[] = {1, 0.5, 0};
    animLabels[] = {"START", "OFF", "IGN ORDIE"};
    animSpeed = 0;
    radius = 0.025;
    animend = "[_this#0, 0, _this#2] call fza_sfmplus_fnc_interactStartSwitch; _this#0 animateSource [""plt_eng1_start"", 0.5];";
    clickSound = "fza_ah64_switch_flip4";
};
class engine1PositionOff {
    positionType = "static";
    position = "ctrlref_p_e1off";
    label = "Engine 1 Off";
    radius = 0.025;
    buttonDown = "[_this#0, 0, ""OFF""] spawn fza_sfmplus_fnc_interactPowerLever;";
    clickSound = "fza_ah64_throttle_idle";
};
class engine1PositionIdle {
    positionType = "static";
    position = "ctrlref_p_e1idle";
    label = "Engine 1 Idle";
    radius = 0.025;
    buttonDown = "[_this#0, 0, ""IDLE""] spawn fza_sfmplus_fnc_interactPowerLever;";
    clickSound = "fza_ah64_throttle_idle";
};
class engine1PositionFly {
    positionType = "static";
    position = "ctrlref_p_e1fly";
    label = "Engine 1 Fly";
    radius = 0.025;
    buttonDown = "[_this#0, 0, ""FLY""] spawn fza_sfmplus_fnc_interactPowerLever;";
    clickSound = "fza_ah64_fake_3D";
};
class engine2StartToggle {
    positionType = "anim";
    position = "ctrlref_p_e2start";
    label = "Engine 2 Start";
    animation = "plt_eng2_start";
    animStates[] = {1, 0.5, 0};
    animLabels[] = {"START", "OFF", "IGN ORDIE"};
    animSpeed = 0;
    radius = 0.025;
    animend = "[_this#0, 1, _this#2] call fza_sfmplus_fnc_interactStartSwitch; _this#0 animateSource [""plt_eng2_start"", 0.5];";
    clickSound = "fza_ah64_switch_flip4";
};
class engine2PositionOff {
    positionType = "static";
    position = "ctrlref_p_e2off";
    label = "Engine 2 Off";
    radius = 0.025;
    buttonDown = "[_this#0, 1, ""OFF""] spawn fza_sfmplus_fnc_interactPowerLever;";
    clickSound = "fza_ah64_throttle_idle";
};
class engine2PositionIdle {
    positionType = "static";
    position = "ctrlref_p_e2idle";
    label = "Engine 2 Idle";
    radius = 0.025;
    buttonDown = "[_this#0, 1, ""IDLE""] spawn fza_sfmplus_fnc_interactPowerLever;";
    clickSound = "fza_ah64_throttle_idle";
};
class engine2PositionFly {
    positionType = "static";
    position = "ctrlref_p_e2fly";
    label = "Engine 2 Fly";
    radius = 0.025;
    buttonDown = "[_this#0, 1, ""FLY""] spawn fza_sfmplus_fnc_interactPowerLever;";
    clickSound = "fza_ah64_fake_3D";
};