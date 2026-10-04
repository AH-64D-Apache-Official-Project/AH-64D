#define CfgUserActionDef(vname, vdisplayName, vtooltip) \
class vname {\
    displayName = vdisplayName;\
    tooltip = vtooltip;\
    onActivate = __EVAL(format["['%1', true] call fza_fnc_coreControlHandle", #vname]);\
    onDeactivate = __EVAL(format["['%1', false] call fza_fnc_coreControlHandle", #vname]);\
}

#define COCKPIT_CONTROL(pilot_mempoint, gunner_mempoint, system, system_name, control, sensitivity, control_name, moving_point) \
class fza_ah64_cockpit_##system##_##control {\
    displayName = __EVAL(format["%1: %2", (toLowerANSI localize system_name), (toLowerANSI localize control_name)]);\
    tooltip = "";\
    onActivate = __EVAL(format["['%1', '%2', '%3', '%4', true] call fza_fnc_coreCockpitControlHandle", #system, #control, pilot_mempoint, gunner_mempoint]);\
    onDeactivate = __EVAL(format["['%1', '%2', '%3', '%4', false] call fza_fnc_coreCockpitControlHandle", #system, #control, pilot_mempoint, gunner_mempoint]);\
};
#define COCKPIT_CONTROL_SEP()

class CfgUserActions {
    CfgUserActionDef(fza_ah64_sightSelectHMD,"$STR_FZA_AH64_SIGHT_SELECT_HMD","$STR_FZA_AH64_SIGHT_SELECT_HMD_INFO");
    CfgUserActionDef(fza_ah64_sightSelectTADS,"$STR_FZA_AH64_SIGHT_SELECT_TADS","$STR_FZA_AH64_SIGHT_SELECT_TADS_INFO");
    CfgUserActionDef(fza_ah64_sightSelectFXD,"$STR_FZA_AH64_SIGHT_SELECT_FXD","$STR_FZA_AH64_SIGHT_SELECT_FXD_INFO");
    CfgUserActionDef(fza_ah64_sightSelectFCR,"$STR_FZA_AH64_SIGHT_SELECT_FCR","$STR_FZA_AH64_SIGHT_SELECT_FCR_INFO");
    CfgUserActionDef(fza_ah64_symbologySelectUp,"$STR_FZA_AH64_SYMBOLOGY_SELECT_UP","$STR_FZA_AH64_SYMBOLOGY_SELECT_UP_INFO");
    CfgUserActionDef(fza_ah64_symbologySelectDown,"$STR_FZA_AH64_SYMBOLOGY_SELECT_DOWN","$STR_FZA_AH64_SYMBOLOGY_SELECT_DOWN_INFO");
    CfgUserActionDef(fza_ah64_symbologySelectPress,"$STR_FZA_AH64_SYMBOLOGY_SELECT_PRESS","$STR_FZA_AH64_SYMBOLOGY_SELECT_PRESS_INFO");
    CfgUserActionDef(fza_ah64_laserDesig,"$STR_FZA_AH64_LASER_DESIG","$STR_FZA_AH64_LASER_DESIG_INFO");
    CfgUserActionDef(fza_ah64_fcrSingleScan,"$STR_FZA_AH64_FCR_SINGLE_SCAN","$STR_FZA_AH64_FCR_SINGLE_SCAN_INFO");
    CfgUserActionDef(fza_ah64_targetStoreUpdate,"$STR_FZA_AH64_TARGET_STORE_UPDATE","$STR_FZA_AH64_TARGET_STORE_UPDATE_INFO");
    CfgUserActionDef(fza_ah64_missileAdvance,"$STR_FZA_AH64_MISSILE_ADVANCE","$STR_FZA_AH64_MISSILE_ADVANCE_INFO");
    CfgUserActionDef(fza_ah64_wasGun,"$STR_FZA_AH64_WAS_GUN","$STR_FZA_AH64_WAS_GUN_INFO");
    CfgUserActionDef(fza_ah64_wasRkt,"$STR_FZA_AH64_WAS_RKT","$STR_FZA_AH64_WAS_RKT_INFO");
    CfgUserActionDef(fza_ah64_wasMsl,"$STR_FZA_AH64_WAS_MSL","$STR_FZA_AH64_WAS_MSL_INFO");
    CfgUserActionDef(fza_ah64_fcrModeSwitch_up,"$STR_FZA_AH64_FCR_MODE_SWITCH_UP","$STR_FZA_AH64_FCR_MODE_SWITCH_UP_INFO");
    CfgUserActionDef(fza_ah64_fcrModeSwitch_down,"$STR_FZA_AH64_FCR_MODE_SWITCH_DOWN","$STR_FZA_AH64_FCR_MODE_SWITCH_DOWN_INFO");
    CfgUserActionDef(fza_ah64_flare,"$STR_FZA_AH64_FLARE","$STR_FZA_AH64_FLARE_INFO");
    CfgUserActionDef(fza_ah64_tadsLHGFov_W,"$STR_FZA_AH64_TADS_LHG_FOV_W","$STR_FZA_AH64_TADS_LHG_FOV_W_INFO");
    CfgUserActionDef(fza_ah64_tadsLHGFov_M,"$STR_FZA_AH64_TADS_LHG_FOV_M","$STR_FZA_AH64_TADS_LHG_FOV_M_INFO");
    CfgUserActionDef(fza_ah64_tadsLHGFov_N,"$STR_FZA_AH64_TADS_LHG_FOV_N","$STR_FZA_AH64_TADS_LHG_FOV_N_INFO");
    CfgUserActionDef(fza_ah64_tadsLHGFov_Z,"$STR_FZA_AH64_TADS_LHG_FOV_Z","$STR_FZA_AH64_TADS_LHG_FOV_Z_INFO");
    CfgUserActionDef(fza_ah64_SensorSelect_FLIR,"$STR_FZA_AH64_SENSOR_SELECT_FLIR","$STR_FZA_AH64_SENSOR_SELECT_FLIR_INFO");
    CfgUserActionDef(fza_ah64_SensorSelect_DTV,"$STR_FZA_AH64_SENSOR_SELECT_DTV","$STR_FZA_AH64_SENSOR_SELECT_DTV_INFO");
    CfgUserActionDef(fza_ah64_SensorSelect_DVO,"$STR_FZA_AH64_SENSOR_SELECT_DVO","$STR_FZA_AH64_SENSOR_SELECT_DVO_INFO");
    CfgUserActionDef(fza_ah64_tadsLHGLmc,"$STR_FZA_AH64_TADS_LHG_LMC","$STR_FZA_AH64_TADS_LHG_LMC_INFO");
    CfgUserActionDef(fza_ah64_collectiveEmergJett,"$STR_FZA_AH64_COLLECTIVE_EMERG_JETT","$STR_FZA_AH64_COLLECTIVE_EMERG_JETT_INFO");

    #include "\fza_ah64_controls\headers\controls.hpp"
};
