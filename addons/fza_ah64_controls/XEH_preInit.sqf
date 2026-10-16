private _projName = "AH-64D Official Project";
#include "\bmkhs_helisim\functions\core\core.hpp"

[
    "fza_ah64_showPopupv2_3",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_SHOW_POPUP"), (localize "STR_FZA_AH64_SETTINGS_SHOW_POPUP_INFO")],
    [_projName, "UI"],
    true,
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_vanillaTargetingEnable",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_VANILLA_TARGETING"), (localize "STR_FZA_AH64_SETTINGS_VANILLA_TARGETING_INFO")],
    [_projName, "UI"],
    [true],
    0,
    {
        profileNamespace setVariable ["fza_ah64_enableTargeting", [0, 1] select _this];
        saveProfileNamespace;
    }
] call CBA_fnc_addSetting;


[
    "fza_ah64_volumeMaster",
    "SLIDER",
    [(localize "STR_FZA_AH64_SETTINGS_MASTER_VOLUME"), (localize "STR_FZA_AH64_SETTINGS_MASTER_VOLUME_INFO")],
    [_projName, "Coms Panel"],
    [0, 5, 3, 1],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_volumeRlwr",
    "SLIDER",
    [(localize "STR_FZA_AH64_SETTINGS_RLWR_VOLUME"), (localize "STR_FZA_AH64_SETTINGS_RLWR_VOLUME_INFO")],
    [_projName, "Coms Panel"],
    [0, 5, 3, 1],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_tadsCycleIncludeDTV",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_TADS_CYCLE_INCLUDE_DTV"), (localize "STR_FZA_AH64_SETTINGS_TADS_CYCLE_INCLUDE_DTV_INFO")],
    [_projName, "TADS Controls"],
    [true],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_tadsCycleIncludeDVO",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_TADS_CYCLE_INCLUDE_DVO"), (localize "STR_FZA_AH64_SETTINGS_TADS_CYCLE_INCLUDE_DVO_INFO")],
    [_projName, "TADS Controls"],
    [true],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_LMCSensitivity",
    "SLIDER",
    [(localize "STR_FZA_AH64_SETTINGS_LMC_SENSITIVITY"), (localize "STR_FZA_AH64_SETTINGS_LMC_SENSITIVITY_INFO")],
    [_projName, "TADS Controls"],
    [0, 1, 0.5, 1],
    2
] call CBA_fnc_addSetting;

fza_ah64_weaponDebug            = false;
fza_ah64_pylonsLastCheckMags    = [];
fza_ah64_overallticker          = 0;
fza_ah64_sideslip               = 0;
fza_ah64_tadsLockCheckRunning   = false;
fza_ah64_introShownThisScenario = false;
private _fovConfig              = configFile >> "CfgVehicles" >> "fza_ah64base" >> "Turrets" >> "MainTurret" >> "OpticsIn";
fza_ah64_tadsFOVs = [
    "Flir_Wide", "Flir_Medium", "Flir_Narrow", "Flir_Zoom", "A3ti_Wide", "A3ti_Medium", "A3ti_Narrow", "A3ti_Zoom", "Dtv_wide", "Dtv_dummyFOV", "Dtv_Narrow", "Dtv_Zoom", "Dvo_Wide", "Dvo_Narrow"
] apply {getNumber (_fovConfig >> _x >> "initfov")};

//Scheduler arrays
fza_ah64_draw3Darray      = [fza_ihadss_fnc_controller, fza_fnc_weaponTurretAim, fza_fcr_fnc_controller, fza_fnc_avionicsSlipIndicator, fza_ase_fnc_aseManager, fza_wca_fnc_update, fza_fire_fnc_update, fza_ufd_fnc_update, fza_dms_fnc_routeData];
fza_ah64_draw3DarraySlow  = [fza_fnc_weaponPylonCheckValid, fza_fnc_fireHandleRearm, fza_cannon_fnc_update];
fza_ah64_eachFrameArray   = [fza_mpd_fnc_update, fza_ihadss_fnc_fovControl, fza_hellfire_fnc_aceController, fza_light_fnc_controller, fza_anim_fnc_animationUpdate];

//Draw3d handler
fza_ah64_draw3Dhandler = addMissionEventHandler["Draw3D", {
    [0] call fza_fnc_coreDraw3Dscheduler;
}];

//EachFrame handler
fza_ah64_eachFrameHandler = addMissionEventHandler["EachFrame", {
    [0] call fza_fnc_coreEachFrameScheduler;
}];

#define OVERRIDE_ACTION(actn) \
    addUserActionEventHandler [actn, "Activate", {[actn, true] call fza_fnc_coreControlHandle}]; \
    addUserActionEventHandler [actn, "Deactivate", {[actn, false] call fza_fnc_coreControlHandle}];

OVERRIDE_ACTION("defaultAction")
OVERRIDE_ACTION("SwitchWeaponGrp1")
OVERRIDE_ACTION("SwitchWeaponGrp2")
OVERRIDE_ACTION("SwitchWeaponGrp3")
OVERRIDE_ACTION("SwitchWeaponGrp4")
OVERRIDE_ACTION("nextWeapon")
OVERRIDE_ACTION("prevWeapon")
OVERRIDE_ACTION("launchCM")
OVERRIDE_ACTION("vehLockTargets")
OVERRIDE_ACTION("zoomIn")
OVERRIDE_ACTION("zoomOut")
OVERRIDE_ACTION("NightVision")
OVERRIDE_ACTION("Headlights")
