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
    CfgUserActionDef(fza_ah64_sightSelectFCR,"$STR_FZA_AH64_SIGHT_SELECT_FCR","$STR_FZA_AH64_SIGHT_SELECT_FCR_INFO");
    CfgUserActionDef(fza_ah64_sightSelectLink,"$STR_FZA_AH64_SIGHT_SELECT_LINK","$STR_FZA_AH64_SIGHT_SELECT_LINK_INFO");
    CfgUserActionDef(fza_ah64_sightSlave,"$STR_FZA_AH64_SIGHT_SLAVE","$STR_FZA_AH64_SIGHT_SLAVE_INFO");
    CfgUserActionDef(fza_ah64_nvsSelectPnvs,"$STR_FZA_AH64_NVS_SELECT_PNVS","$STR_FZA_AH64_NVS_SELECT_PNVS_INFO");
    CfgUserActionDef(fza_ah64_nvsSelectTads,"$STR_FZA_AH64_NVS_SELECT_TADS","$STR_FZA_AH64_NVS_SELECT_TADS_INFO");
    CfgUserActionDef(fza_ah64_symbologySelectUp,"$STR_FZA_AH64_SYMBOLOGY_SELECT_UP","$STR_FZA_AH64_SYMBOLOGY_SELECT_UP_INFO");
    CfgUserActionDef(fza_ah64_symbologySelectDown,"$STR_FZA_AH64_SYMBOLOGY_SELECT_DOWN","$STR_FZA_AH64_SYMBOLOGY_SELECT_DOWN_INFO");
    CfgUserActionDef(fza_ah64_symbologySelectPress,"$STR_FZA_AH64_SYMBOLOGY_SELECT_PRESS","$STR_FZA_AH64_SYMBOLOGY_SELECT_PRESS_INFO");
    CfgUserActionDef(fza_ah64_laserDesig,"$STR_FZA_AH64_LASER_DESIG","$STR_FZA_AH64_LASER_DESIG_INFO");
    CfgUserActionDef(fza_ah64_fcrSingleScan,"$STR_FZA_AH64_FCR_SINGLE_SCAN","$STR_FZA_AH64_FCR_SINGLE_SCAN_INFO");
    CfgUserActionDef(fza_ah64_cpgStoreUpdate,"$STR_FZA_AH64_CPG_STORE_UPDATE","$STR_FZA_AH64_CPG_STORE_UPDATE_INFO");
    CfgUserActionDef(fza_ah64_missileAdvance,"$STR_FZA_AH64_MISSILE_ADVANCE","$STR_FZA_AH64_MISSILE_ADVANCE_INFO");
    CfgUserActionDef(fza_ah64_wasGun,"$STR_FZA_AH64_WAS_GUN","$STR_FZA_AH64_WAS_GUN_INFO");
    CfgUserActionDef(fza_ah64_wasRkt,"$STR_FZA_AH64_WAS_RKT","$STR_FZA_AH64_WAS_RKT_INFO");
    CfgUserActionDef(fza_ah64_wasMsl,"$STR_FZA_AH64_WAS_MSL","$STR_FZA_AH64_WAS_MSL_INFO");
    CfgUserActionDef(fza_ah64_fcrModeGTM,"$STR_FZA_AH64_FCR_MODE_GTM","$STR_FZA_AH64_FCR_MODE_GTM_INFO");
    CfgUserActionDef(fza_ah64_fcrModeRMAP,"$STR_FZA_AH64_FCR_MODE_RMAP","$STR_FZA_AH64_FCR_MODE_RMAP_INFO");
    CfgUserActionDef(fza_ah64_fcrModeATM,"$STR_FZA_AH64_FCR_MODE_ATM","$STR_FZA_AH64_FCR_MODE_ATM_INFO");
    CfgUserActionDef(fza_ah64_fcrModeTPM,"$STR_FZA_AH64_FCR_MODE_TPM","$STR_FZA_AH64_FCR_MODE_TPM_INFO");
    CfgUserActionDef(fza_ah64_fcrScanSize_W,"$STR_FZA_AH64_FCR_SCAN_SIZE_W","$STR_FZA_AH64_FCR_SCAN_SIZE_W_INFO");
    CfgUserActionDef(fza_ah64_fcrScanSize_M,"$STR_FZA_AH64_FCR_SCAN_SIZE_M","$STR_FZA_AH64_FCR_SCAN_SIZE_M_INFO");
    CfgUserActionDef(fza_ah64_fcrScanSize_N,"$STR_FZA_AH64_FCR_SCAN_SIZE_N","$STR_FZA_AH64_FCR_SCAN_SIZE_N_INFO");
    CfgUserActionDef(fza_ah64_fcrScanSize_Z,"$STR_FZA_AH64_FCR_SCAN_SIZE_Z","$STR_FZA_AH64_FCR_SCAN_SIZE_Z_INFO");
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

    // MPD minigame input - generic up/down/left/right/fire, forwarded to fza_mg_fnc_minigameHandleInput.
    CfgUserActionDef(fza_minigame_up,"$STR_FZA_AH64_MINIGAME_UP","$STR_FZA_AH64_MINIGAME_UP_INFO");
    CfgUserActionDef(fza_minigame_down,"$STR_FZA_AH64_MINIGAME_DOWN","$STR_FZA_AH64_MINIGAME_DOWN_INFO");
    CfgUserActionDef(fza_minigame_left,"$STR_FZA_AH64_MINIGAME_LEFT","$STR_FZA_AH64_MINIGAME_LEFT_INFO");
    CfgUserActionDef(fza_minigame_right,"$STR_FZA_AH64_MINIGAME_RIGHT","$STR_FZA_AH64_MINIGAME_RIGHT_INFO");
    CfgUserActionDef(fza_minigame_fire,"$STR_FZA_AH64_MINIGAME_FIRE","$STR_FZA_AH64_MINIGAME_FIRE_INFO");

    #include "\fza_ah64_controls\headers\controls.hpp"
};
