#pragma hemtt suppress pw3_padded_arg file

CFG_BUTTON_DOWN(MonicleToggle, "ctrlref_p_monocle", "$STR_FZA_AH64_EQUIP_STOW_MONOCLE", 0.1, [ARR_3(_this#0, 'ihadss', 'stow')] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");
CFG_BUTTON_DOWN(ArmSafeToggle, "plt_btn_arm_safe", "$STR_FZA_AH64_TOGGLE_ARM_SAFE", 0.025, [ARR_3(_this#0, 'armSafeBtn', 'armSafe')] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");
CFG_BUTTON_DOWN(GroundOverrideToggle, "plt_btn_gnd_oride", "$STR_FZA_AH64_ACTIVATE_GROUND_OVERRIDE", 0.025, [ARR_3(_this#0, 'gndOrideBtn', 'gndOride')] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");
CFG_BUTTON_DOWN(MasterCautionButton, "plt_btn_mstr_caut", "$STR_FZA_AH64_ACKNOWLEDGE_MASTER_CAUTION", 0.025, [ARR_3(_this#0, 'mstrCautBtn', 'mstrCaut')] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");
CFG_BUTTON_DOWN(MasterWarningButton, "plt_btn_mstr_warn", "$STR_FZA_AH64_ACKNOWLEDGE_MASTER_WARNING", 0.025, [ARR_3(_this#0, 'mstrWarnBtn', 'mstrWarn')] call fza_fnc_coreCockpitInteract, "fza_ah64_switch_flip4");
// Click toggles; scroll down sets, scroll up releases. Set from animStart so the handle's onPhaseChanged reset sees the new value.
class ParkingBrakeToggle {
    positionType = "static";
    position = "parkBrakeHandle";
    label = "$STR_FZA_AH64_TOGGLE_PARKING_BRAKE";
    radius = 0.04;
    animation = "parkBrakeHandle";
    animStates[] = {0, 1};
    animLabels[] = {"$STR_FZA_AH64_PARKING_BRAKE_OFF", "$STR_FZA_AH64_PARKING_BRAKE_ON"};
    animSpeed = 1;
    animStart = "['parkBrake', _this # 3, _this # 0] call bmkhs_fnc_controlSet";
    buttonDown = "[_this # 0, 'wheels', 'parkBrake'] call fza_fnc_coreCockpitInteract";
    clickSound = "fza_ah64_switch_flip4";
};
CFG_BUTTON_UP_CONDITIONS(ActivateKeyboardUnit, isNil 'fza_ku_keyDownEvent', "plt_ku_ctr", "$STR_FZA_AH64_ACTIVATE_KEYBOARD_UNIT", 0.1, _this#0 call fza_ku_fnc_activateInput, "fza_ah64_switch_flip4");
CFG_BUTTON_DOWN_CONDITIONS(DeactivateKeyboardUnit, !isNil 'fza_ku_keyDownEvent', "plt_ku_ctr", "$STR_FZA_AH64_DEACTIVATE_KEYBOARD_UNIT", 0.1, _this#0 call fza_ku_fnc_deactivateInput, "fza_ah64_switch_flip4");
