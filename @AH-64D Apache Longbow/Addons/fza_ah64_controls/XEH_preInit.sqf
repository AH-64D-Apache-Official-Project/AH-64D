private _projName = "AH-64D Official Project";
#include "\fza_ah64_sfmplus\headers\core.hpp"
[
    "fza_ah64_showPopupv2_2",
    "CHECKBOX",
    ["Show Popup Intro", "Show popup when the player gets into an Apache"],
    [_projName, "UI"],
    true,
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_freeCursorSensitivity",
    "SLIDER",
    "Free cursor mode sensitivity",
    [_projName, "Control"],
    [0, 0.1, 0.05, 2],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_freeCursorfreelooklock",
    "CHECKBOX",
    "Lock the cursor when in free look",
    [_projName, "Control"],
    [true],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_enableClickHelper",
    "CHECKBOX",
    ["Enable cockpit hints", "Disabling this will hide the Cockpit hints"],
    [_projName, "UI"],
    [true],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_vanillaTargetingEnable",
    "CHECKBOX",
    ["Show vanilla targeting information (restart required)", "Disabling this will hide vanilla targeting information (restart needed)"],
    [_projName, "UI"],
    [true],
    0,
    {
        profileNamespace setVariable ["fza_ah64_enableTargeting", [0, 1] select _this];
        saveProfileNamespace;
    }
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusCollectiveControl",
    "LIST",
    ["Collective Control", "HOTAS is for users using a Throttle. Keyboard/Gamepad is for users using a gamepad with buttons or keyboard for collective."],
    [_projName, "Flight model"],
    [[HOTAS,KEYBOARD],["HOTAS","Keyboard/Gamepad"],1],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusSpringlessCyclic",
    "CHECKBOX",
    ["Springless Cyclic", "When enabled, cyclic force trim is disabled. This is for users with force feedback or springless HOTAS."],
    [_projName, "Flight model"],
    [false],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusSpringlessPedals",
    "CHECKBOX",
    ["Springless Pedals", "When enabled, pedal force trim is disabled. This is for users with force feedback or springless pedals. This option also disables Heading Hold."],
    [_projName, "Flight model"],
    [false],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusKeyboardStickyPitch",
    "CHECKBOX",
    ["Keyboard Sticky Pitch", "DO NOT USE THIS IF USING HOTAS OR GAMEPAD! When enabled, keyboard input is continously updated while the input key is held down"],
    [_projName, "Flight model"],
    [false],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusKeyboardStickyRoll",
    "CHECKBOX",
    ["Keyboard Sticky Roll", "DO NOT USE THIS IF USING HOTAS OR GAMEPAD! When enabled, keyboard input is continously updated while the input key is held down."],
    [_projName, "Flight model"],
    [false],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusKeyboardStickyYaw",
    "CHECKBOX",
    ["Keyboard Sticky Yaw", "DOES NOT WORK WITH AUTO PEDAL! When enabled, keyboard input is continously updated while the input key is held down."],
    [_projName, "Flight model"],
    [false],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusAutoPedal",
    "CHECKBOX",
    ["Keyboard Auto Pedal", "DOES NOT WORK WITH STICKY YAW! When enabled, the pedals are automatically managed by AI."],
    [_projName, "Flight model"],
    [false],
    2
] call CBA_fnc_addSetting;


[
    "fza_ah64_sfmPlusMouseAsJoystick",
    "CHECKBOX",
    ["Mouse as Joystick", "DO NOT USE THIS IF USING HOTAS OR GAMEPAD! Enables the mouse sensitivity option."],
    [_projName, "Flight model"],
    [false],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusMouseSense",
    "SLIDER",
    ["Mouse Sensitivity", "Controls the sensitivity of the Mouse when used as a Joystick."],
    [_projName, "Flight model"],
    [0.1, 1.0, 1.0, 1],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmplusEnvironment",
    "LIST",
    ["Aircraft Environmental Settings", "Standard day is Sea Level and 15 deg C.
    Europe is a base altitude of 800ft, with a Summer temperature of 20 deg C and a Winter temperature of 0 deg C. 
    The Middle East is a base altitude of 1,800ft and a temperature of 30 deg C. 
    Central Asia is a base altitude of 5000ft, with a Summer temperature of 30 deg C and a winter temperature of -5 deg C. 
    Asia is a base altitude of 3100ft and a temperature of 25 deg C."],
    [_projName, "Flight model"],
    [[ISA_STD, EUROPE_SUMMER, EUROPE_WINTER, MIDDLE_EAST, CENTRAL_ASIA_SUMMER, CENTRAL_ASIA_WINTER, ASIA],["Standard Day", "Europe - Summer", "Europe - Winter", "Middle East", "Cental Asia - Summer", "Central Asia - Winter", "Asia"],1],
    0
] call CBA_fnc_addSetting;

[
    "fza_ah64_sfmPlusVrsWarning",
    "CHECKBOX",
    ["Enable VRS Warning", "When enabled, will alert the pilot to the onset of VRS."],
    [_projName, "Flight model"],
    [false],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_aiFireControl",
    "CHECKBOX",
    ["Fire suppresion", "Enabling an AI Pilot to handle engine fires"],
    [_projName, "AI Control settings"],
    [true],
    0
] call CBA_fnc_addSetting;

[
    "fza_ah64_aiFireResponse",
    "SLIDER",
    ["Fire suppresion response time", "This setting controls how long it takes the Ai to handle an engine fire"],
    [_projName, "AI Control settings"],
    [4, 30, 15, 0],
    0
] call CBA_fnc_addSetting;

[
    "fza_ah64_aiFloodlight",
    "CHECKBOX",
    ["Cockpit lighting control", "Enabling an AI to turn on the cockpit lighting near dark (does not work with full AI crew)"],
    [_projName, "AI Control settings"],
    [false],
    0
] call CBA_fnc_addSetting;

[
    "fza_ah64_volumeMaster",
    "SLIDER",
    ["Master volume Knob", "Temporary Master volume control"],
    [_projName, "Coms Panel"],
    [0, 5, 3, 1],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_volumeRlwr",
    "SLIDER",
    ["RLWR volume Knob", "Temporary RLWR volume control"],
    [_projName, "Coms Panel"],
    [0, 5, 3, 1],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_tadsCycleIncludeDTV",
    "CHECKBOX",
    ["NV Cycle Include DTV", "With this the Night vision button will also cycle through DTV and not just BHOT & WHOT"],
    [_projName, "TADS Controls"],
    [true],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_tadsCycleIncludeDVO",
    "CHECKBOX",
    ["NV Cycle Include DVO", "With this the Night vision button will also cycle through DVO and not just BHOT & WHOT"],
    [_projName, "TADS Controls"],
    [true],
    2
] call CBA_fnc_addSetting;

[
    "fza_ah64_LMCSensitivity",
    "SLIDER",
    ["LMC Sensitivity", "(LMC) Linear motion compensator input sensitivity control"],
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
fza_ah64_draw3Darray      = [fza_ihadss_fnc_controller, fza_fnc_weaponTurretAim, fza_fcr_fnc_controller, fza_fnc_avionicsSlipIndicator, fza_ase_fnc_aseManager, fza_wca_fnc_update, fza_fire_fnc_update, fza_ufd_fnc_update, fza_dms_fnc_routeData];
fza_ah64_draw3DarraySlow  = [fza_fnc_weaponPylonCheckValid, fza_fnc_fireHandleRearm, fza_aiCrew_fnc_floodlight, fza_cannon_fnc_update, fza_systems_fnc_repair];
fza_ah64_eachFrameArray   = [fza_mpd_fnc_update, fza_ihadss_fnc_fovControl, fza_systems_fnc_coreUpdate, fza_hellfire_fnc_aceController, fza_light_fnc_controller, fza_sfmplus_fnc_probes, fza_sfmplus_fnc_coreUpdate];

//Draw3d handler
fza_ah64_draw3Dhandler = addMissionEventHandler["Draw3d", {
    [0] call fza_fnc_coreDraw3Dscheduler;
}];

//EachFrame handler
fza_ah64_eachFrameHandler = addMissionEventHandler["EachFrame", {
    [0] call fza_fnc_coreEachFrameScheduler;
}];

//fixedUpdated handler
fza_ah64_currentTime        = 0.0;
fza_ah64_deltaTime          = 0.0;
fza_ah64_previousTime       = 0.0;
fza_ah64_accumulator        = 0.0;
fza_ah64_fixedUpdateHandler = addMissionEventHandler["EachFrame", {
    [0] call fza_fnc_coreFixedUpdateScheduler;
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
