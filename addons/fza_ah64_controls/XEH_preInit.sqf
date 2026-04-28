private _projName = "AH-64D Official Project";
#include "\fza_ah64_sfmplus\headers\core.hpp"
[
    "fza_ah64_showPopupv2_2",
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
    "fza_ah64_sfmplusRealismSetting",
    "LIST",
    [(localize "STR_FZA_AH64_SETTINGS_HELISIM_REALISM"), (localize "STR_FZA_AH64_SETTINGS_HELISIM_REALISM_INFO")],
    [_projName, "Flight model"],
    [[CASUAL, REALISTIC],[(localize "STR_FZA_AH64_SETTINGS_REALISM_CASUAL"), (localize "STR_FZA_AH64_SETTINGS_REALISM_REALISTIC")],0],
    0
] call CBA_fnc_addSetting;

[
    "fza_sfmplus_cyclicCenterTrimMode",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_CYCLIC_CENTER_TRIM_MODE"), (localize "STR_FZA_AH64_SETTINGS_CYCLIC_CENTER_TRIM_MODE_INFO")],
    [_projName, "Flight model"],
    [false],
    2
] call CBA_fnc_addSetting;

[
    "fza_sfmplus_pedalCenterTrimMode",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_PEDAL_CENTER_TRIM_MODE"), (localize "STR_FZA_AH64_SETTINGS_PEDAL_CENTER_TRIM_MODE_INFO")],
    [_projName, "Flight model"],
    [false],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusSpringlessCyclic",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_SPRINGLESS_CYCLIC"), (localize "STR_FZA_AH64_SETTINGS_SPRINGLESS_CYCLIC_INFO")],
    [_projName, "Flight model"],
    [false],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusSpringlessPedals",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_SPRINGLESS_PEDALS"), (localize "STR_FZA_AH64_SETTINGS_SPRINGLESS_PEDALS_INFO")],
    [_projName, "Flight model"],
    [false],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusKeyboardStickyPitch",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_KEYBOARD_STICKY_PITCH"), (localize "STR_FZA_AH64_SETTINGS_KEYBOARD_STICKY_PITCH_INFO")],
    [_projName, "Flight model"],
    [false],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusKeyboardStickyRoll",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_KEYBOARD_STICKY_ROLL"), (localize "STR_FZA_AH64_SETTINGS_KEYBOARD_STICKY_ROLL_INFO")],
    [_projName, "Flight model"],
    [false],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusKeyboardStickyYaw",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_KEYBOARD_STICKY_YAW"), (localize "STR_FZA_AH64_SETTINGS_KEYBOARD_STICKY_YAW_INFO")],
    [_projName, "Flight model"],
    [false],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusAutoPedal",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_KEYBOARD_AUTO_PEDAL"), (localize "STR_FZA_AH64_SETTINGS_KEYBOARD_AUTO_PEDAL_INFO")],
    [_projName, "Flight model"],
    [true],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusMouseAsJoystick",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_MOUSE_AS_JOYSTICK"), (localize "STR_FZA_AH64_SETTINGS_MOUSE_AS_JOYSTICK_INFO")],
    [_projName, "Flight model"],
    [false],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusMouseSense",
    "SLIDER",
    [(localize "STR_FZA_AH64_SETTINGS_MOUSE_SENSITIVITY"), (localize "STR_FZA_AH64_SETTINGS_MOUSE_SENSITIVITY_INFO")],
    [_projName, "Flight model"],
    [0.1, 1.0, 1.0, 1],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmplusEnvironment",
    "LIST",
    [(localize "STR_FZA_AH64_SETTINGS_ENVIRONMENT"), (localize "STR_FZA_AH64_SETTINGS_ENVIRONMENT_INFO")],
    [_projName, "Flight model"],
    [[ISA_STD, EUROPE_SUMMER, EUROPE_WINTER, MIDDLE_EAST, CENTRAL_ASIA_SUMMER, CENTRAL_ASIA_WINTER, ASIA],[(localize "STR_FZA_AH64_SETTINGS_ENVIRONMENT_STANDARD_DAY"), (localize "STR_FZA_AH64_SETTINGS_ENVIRONMENT_EUROPE_SUMMER"), (localize "STR_FZA_AH64_SETTINGS_ENVIRONMENT_EUROPE_WINTER"), (localize "STR_FZA_AH64_SETTINGS_ENVIRONMENT_MIDDLE_EAST"), (localize "STR_FZA_AH64_SETTINGS_ENVIRONMENT_CENTRAL_ASIA_SUMMER"), (localize "STR_FZA_AH64_SETTINGS_ENVIRONMENT_CENTRAL_ASIA_WINTER"), (localize "STR_FZA_AH64_SETTINGS_ENVIRONMENT_ASIA")],1],
    0
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusVrsWarning",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_VRS_WARNING"), (localize "STR_FZA_AH64_SETTINGS_VRS_WARNING_INFO")],
    [_projName, "Flight model"],
    [false],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusFmDebug",
    "CHECKBOX",
    [(localize "STR_FZA_AH64_SETTINGS_FM_DEBUG"), (localize "STR_FZA_AH64_SETTINGS_FM_DEBUG_INFO")],
    [_projName, "Flight model"],
    [false],
    2
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
fza_ah64_lastFrameGetIn         = false;
private _fovConfig              = configFile >> "CfgVehicles" >> "fza_ah64base" >> "Turrets" >> "MainTurret" >> "OpticsIn";
fza_ah64_tadsFOVs = [
    "Flir_Wide", "Flir_Medium", "Flir_Narrow", "Flir_Zoom", "A3ti_Wide", "A3ti_Medium", "A3ti_Narrow", "A3ti_Zoom", "Dtv_wide", "Dtv_dummyFOV", "Dtv_Narrow", "Dtv_Zoom", "Dvo_Wide", "Dvo_Narrow"
] apply {getNumber (_fovConfig >> _x >> "initfov")};

//Scheduler arrays
fza_ah64_draw3Darray      = [fza_ihadss_fnc_controller, fza_weapons_fnc_controller, fza_fcr_fnc_controller, fza_fnc_avionicsSlipIndicator, fza_ase_fnc_aseManager, fza_wca_fnc_update, fza_fire_fnc_update, fza_ufd_fnc_update, fza_dms_fnc_routeData];
fza_ah64_draw3DarraySlow  = [fza_weapons_fnc_pylonCheckValid, fza_fnc_fireHandleRearm, fza_aiCrew_fnc_floodlight, fza_cannon_fnc_update, fza_systems_fnc_repair];
fza_ah64_eachFrameArray   = [fza_mpd_fnc_update, fza_ihadss_fnc_fovControl, fza_systems_fnc_coreUpdate, fza_hellfire_fnc_aceController, fza_light_fnc_controller, fza_sfmplus_fnc_probes, fza_sfmplus_fnc_coreUpdate, fza_sfmplus_fnc_coreUpdateFlightModel];

//Draw3d handler
fza_ah64_draw3Dhandler = addMissionEventHandler["Draw3D", {
    [0] call fza_fnc_coreDraw3Dscheduler;
}];

//EachFrame handler
fza_ah64_eachFrameHandler = addMissionEventHandler["EachFrame", {
    [0] call fza_fnc_coreEachFrameScheduler;
}];

//fixedUpdated handler
//fza_ah64_currentTime        = 0.0;
//fza_ah64_deltaTime          = 0.0;
//fza_ah64_previousTime       = 0.0;
//fza_ah64_accumulator        = 0.0;
//fza_ah64_fixedUpdateHandler = addMissionEventHandler["EachFrame", {
//    [0] call fza_fnc_coreFixedUpdateScheduler;
//}];

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
