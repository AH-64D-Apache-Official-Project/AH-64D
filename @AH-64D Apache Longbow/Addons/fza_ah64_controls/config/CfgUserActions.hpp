#define CfgUserActionDef(vname, vdisplayName, vtooltip) \
class vname {\
    displayName = vdisplayName;\
    tooltip = vtooltip;\
    onActivate = __EVAL(format["['%1', true] call fza_fnc_coreControlHandle", #vname]);\
    onDeactivate = __EVAL(format["['%1', false] call fza_fnc_coreControlHandle", #vname]);\
}

#define COCKPIT_CONTROL(pilot_mempoint, gunner_mempoint, system, system_name, control, sensitivity, control_name, moving_point) \
class fza_ah64_cockpit_##system##_##control {\
    displayName = __EVAL(format["%1: %2", system_name, control_name]);\
    tooltip = "";\
    onActivate = __EVAL(format["['%1', '%2', '%3', '%4', true] call fza_fnc_coreCockpitControlHandle", #system, #control, pilot_mempoint, gunner_mempoint]);\
    onDeactivate = __EVAL(format["['%1', '%2', '%3', '%4', false] call fza_fnc_coreCockpitControlHandle", #system, #control, pilot_mempoint, gunner_mempoint]);\
};
#define COCKPIT_CONTROL_SEP 

#define CfgUserAnalogDef(vname, vdisplayName, vtooltip) \
class vname {\
    displayName           = vdisplayName;\
    tooltip               = vtooltip;\
    onAnalog              = __EVAL(format["['%1', _this] call fza_sfmplus_fnc_analogHandler", #vname]);\
    analogChangeThreshold = 0.01; \
}
#define CfgUserNonAnalogDef(vname, vdisplayName, vtooltip) \
class vname {\
    displayName           = vdisplayName;\
    tooltip               = vtooltip;\
    onActivate            = __EVAL(format["['%1', true]  call fza_sfmplus_fnc_nonAnalogHandler", #vname]);\
    onDeactivate          = __EVAL(format["['%1', false] call fza_sfmplus_fnc_nonAnalogHandler", #vname]);\
}

class CfgUserActions {
    CfgUserActionDef(fza_ah64_sightSelectHMD, "$STR_FZA_AH64_SIGHT_SELECT_HMD", "$STR_FZA_AH64_SIGHT_SELECT_HMD_INFO");
    CfgUserActionDef(fza_ah64_sightSelectTADS, "$STR_FZA_AH64_SIGHT_SELECT_TADS", "$STR_FZA_AH64_SIGHT_SELECT_TADS_INFO");
    CfgUserActionDef(fza_ah64_sightSelectFXD, "$STR_FZA_AH64_SIGHT_SELECT_FXD", "$STR_FZA_AH64_SIGHT_SELECT_FXD_INFO");
    CfgUserActionDef(fza_ah64_sightSelectFCR, "$STR_FZA_AH64_SIGHT_SELECT_FCR", "$STR_FZA_AH64_SIGHT_SELECT_FCR_INFO");
    CfgUserActionDef(fza_ah64_symbologySelectUp, "$STR_FZA_AH64_SYMBOLOGY_SELECT_UP", "$STR_FZA_AH64_SYMBOLOGY_SELECT_UP_INFO");
    CfgUserActionDef(fza_ah64_symbologySelectDown, "$STR_FZA_AH64_SYMBOLOGY_SELECT_DOWN", "$STR_FZA_AH64_SYMBOLOGY_SELECT_DOWN_INFO");
    CfgUserActionDef(fza_ah64_symbologySelectPress, "$STR_FZA_AH64_SYMBOLOGY_SELECT_PRESS", "$STR_FZA_AH64_SYMBOLOGY_SELECT_PRESS_INFO");
    CfgUserActionDef(fza_ah64_laserDesig, "$STR_FZA_AH64_LASER_DESIG", "$STR_FZA_AH64_LASER_DESIG_INFO");
    CfgUserActionDef(fza_ah64_fcrSingleScan, "$STR_FZA_AH64_FCR_SINGLE_SCAN", "$STR_FZA_AH64_FCR_SINGLE_SCAN_INFO");
    CfgUserActionDef(fza_ah64_targetStoreUpdate, "$STR_FZA_AH64_TARGET_STORE", "$STR_FZA_AH64_TARGET_STORE_INFO");
    CfgUserActionDef(fza_ah64_missileAdvance, "$STR_FZA_AH64_MISSILE_ADVANCE", "$STR_FZA_AH64_MISSILE_ADVANCE_INFO");
    CfgUserActionDef(fza_ah64_wasGun, "$STR_FZA_AH64_WAS_GUN", "$STR_FZA_AH64_WAS_GUN_INFO");
    CfgUserActionDef(fza_ah64_wasRkt, "$STR_FZA_AH64_WAS_ROCKETS", "$STR_FZA_AH64_WAS_ROCKETS_INFO");
    CfgUserActionDef(fza_ah64_wasMsl, "$STR_FZA_AH64_WAS_MISSILES", "$STR_FZA_AH64_WAS_MISSILES_INFO");
    CfgUserActionDef(fza_ah64_forceTrimHoldModeSwitch_up, "$STR_FZA_AH64_FORCE_TRIM_HOLD_UP", "$STR_FZA_AH64_FORCE_TRIM_HOLD_UP_INFO");
    CfgUserActionDef(fza_ah64_forceTrimHoldModeSwitch_right, "$STR_FZA_AH64_FORCE_TRIM_HOLD_RIGHT", "$STR_FZA_AH64_FORCE_TRIM_HOLD_RIGHT_INFO");
    CfgUserActionDef(fza_ah64_forceTrimHoldModeSwitch_down, "$STR_FZA_AH64_FORCE_TRIM_HOLD_DOWN", "$STR_FZA_AH64_FORCE_TRIM_HOLD_DOWN_INFO");
    CfgUserActionDef(fza_ah64_forceTrimHoldModeSwitch_left, "$STR_FZA_AH64_FORCE_TRIM_HOLD_LEFT", "$STR_FZA_AH64_FORCE_TRIM_HOLD_LEFT_INFO");
    CfgUserActionDef(fza_ah64_fcrModeSwitch_up, "$STR_FZA_AH64_FCR_GROUND_TARGETING_MODE", "$STR_FZA_AH64_FCR_GROUND_TARGETING_MODE_INFO");
    CfgUserActionDef(fza_ah64_fcrModeSwitch_down, "$STR_FZA_AH64_FCR_AIR_TARGETING_MODE", "$STR_FZA_AH64_FCR_AIR_TARGETING_MODE_INFO");
    CfgUserActionDef(fza_ah64_flare, "$STR_FZA_AH64_DEPLOY_FLARE", "$STR_FZA_AH64_DEPLOY_FLARE_INFO");
    CfgUserActionDef(fza_ah64_tadsLHGFov_W, "$STR_FZA_AH64_TADS_FOV_WIDE", "$STR_FZA_AH64_TADS_FOV_WIDE_INFO");
    CfgUserActionDef(fza_ah64_tadsLHGFov_M, "$STR_FZA_AH64_TADS_FOV_MEDIUM", "$STR_FZA_AH64_TADS_FOV_MEDIUM_INFO");
    CfgUserActionDef(fza_ah64_tadsLHGFov_N, "$STR_FZA_AH64_TADS_FOV_NARROW", "$STR_FZA_AH64_TADS_FOV_NARROW_INFO");
    CfgUserActionDef(fza_ah64_tadsLHGFov_Z, "$STR_FZA_AH64_TADS_FOV_ZOOM", "$STR_FZA_AH64_TADS_FOV_ZOOM_INFO");
    CfgUserActionDef(fza_ah64_SensorSelect_FLIR, "$STR_FZA_AH64_TADS_SENSOR_FLIR", "$STR_FZA_AH64_TADS_SENSOR_FLIR_INFO");
    CfgUserActionDef(fza_ah64_SensorSelect_DTV, "$STR_FZA_AH64_TADS_SENSOR_DTV", "$STR_FZA_AH64_TADS_SENSOR_DTV_INFO");
    CfgUserActionDef(fza_ah64_SensorSelect_DVO, "$STR_FZA_AH64_TADS_SENSOR_DVO", "$STR_FZA_AH64_TADS_SENSOR_DVO_INFO");
    CfgUserActionDef(fza_ah64_tadsLHGLmc, "$STR_FZA_AH64_TADS_LMC_BUTTON", "$STR_FZA_AH64_TADS_LMC_BUTTON_INFO");
    CfgUserActionDef(fza_ah64_stickyControlInterupt, "$STR_FZA_AH64_STICKY_CONTROL_INTERUPT", "$STR_FZA_AH64_STICKY_CONTROL_INTERUPT_INFO");
    CfgUserActionDef(fza_ah64_forceTrimPanicButton, "$STR_FZA_AH64_FORCE_TRIM_PANIC_BUTTON", "$STR_FZA_AH64_FORCE_TRIM_PANIC_BUTTON_INFO");
    CfgUserActionDef(fza_ah64_collectiveEmergJett, "$STR_FZA_AH64_COLLECTIVE_EMERGENCY_JETTISON", "$STR_FZA_AH64_COLLECTIVE_EMERGENCY_JETTISON_INFO");
    CfgUserAnalogDef(fza_ah64_cyclicForward, "$STR_FZA_AH64_CYCLIC_FORWARD", "$STR_FZA_AH64_CYCLIC_FORWARD_INFO");
    CfgUserAnalogDef(fza_ah64_cyclicBackward, "$STR_FZA_AH64_CYCLIC_BACKWARD", "$STR_FZA_AH64_CYCLIC_BACKWARD_INFO");
    CfgUserAnalogDef(fza_ah64_cyclicLeft, "$STR_FZA_AH64_CYCLIC_LEFT", "$STR_FZA_AH64_CYCLIC_LEFT_INFO");
    CfgUserAnalogDef(fza_ah64_cyclicRight, "$STR_FZA_AH64_CYCLIC_RIGHT", "$STR_FZA_AH64_CYCLIC_RIGHT_INFO");
    CfgUserAnalogDef(fza_ah64_pedalLeft, "$STR_FZA_AH64_PEDAL_LEFT", "$STR_FZA_AH64_PEDAL_LEFT_INFO");
    CfgUserAnalogDef(fza_ah64_pedalRight, "$STR_FZA_AH64_PEDAL_RIGHT", "$STR_FZA_AH64_PEDAL_RIGHT_INFO");
    CfgUserAnalogDef(fza_ah64_collectiveUp, "$STR_FZA_AH64_COLLECTIVE_UP", "$STR_FZA_AH64_COLLECTIVE_UP_INFO");
    CfgUserAnalogDef(fza_ah64_collectiveDn, "$STR_FZA_AH64_COLLECTIVE_DOWN", "$STR_FZA_AH64_COLLECTIVE_DOWN_INFO");
    CfgUserNonAnalogDef(fza_ah64_kbCollectiveUp, "$STR_FZA_AH64_KB_COLLECTIVE_UP", "$STR_FZA_AH64_KB_COLLECTIVE_UP_INFO");
    CfgUserNonAnalogDef(fza_ah64_kbCollectiveDn, "$STR_FZA_AH64_KB_COLLECTIVE_DOWN", "$STR_FZA_AH64_KB_COLLECTIVE_DOWN_INFO");
    #include "\fza_ah64_controls\headers\controls.h"
};