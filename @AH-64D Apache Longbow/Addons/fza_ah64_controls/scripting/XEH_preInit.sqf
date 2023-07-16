private _projName = "AH-64D Official Project";
#include "\fza_ah64_sfmplus\headers\core.hpp"
[
    "fza_ah64_showPopup",
    "CHECKBOX",
    ["Show Popup Intro", "Show popup when the player gets into an Apache"],
    [_projName, "UI"],
    true
] call CBA_fnc_addSetting;

[
    "fza_ah64_headTrackAllowCursorMove",
    "CHECKBOX",
    "Allow cursor movement while in head tracking mode",
    [_projName, "Control"],
    [true],
    0
] call CBA_fnc_addSetting;

[
    "fza_ah64_headTrackSensitivity",
    "SLIDER",
    "Head tracking mode cursor sensitivity",
    [_projName, "Control"],
    [0, 1, 0.5, 2],
    0
] call CBA_fnc_addSetting;

[
    "fza_ah64_enableClickHelper",
    "CHECKBOX",
    ["Enable cockpit hints", "Disabling this will hide the Cockpit hints"],
    [_projName, "UI"],
    [true]
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
    "fza_ah64_sfmPlusStabilatorEnabled",
    "LIST",
    ["Enable stabilator simulation", "The stabilator provides an expanded pitch range allowing for more accurate cruise speeds during flight. The stabilator is optimized for Joysticks and may be more difficult to use with a Keyboard & Mouse."],
    [_projName, "Flight model"],
    [[STABILATOR_MODE_ALWAYSENABLED,STABILATOR_MODE_JOYSTICKONLY,STABILATOR_MODE_ALWAYSDISABLED],["Always Enabled", "Joystick Only","Always Disabled"],1],
    0
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
    "fza_ah64_sfmplusEnableTorqueSim",
    "CHECKBOX",
    ["Main Rotor Torque Simulation", "Turns off main rotor torque simulation to prevent the nose from turning right when collective is increased. Meant for users who fly mouse & keyboard and do not have rudder pedals."],
    [_projName, "Flight model"],
    [true],
    0
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

fza_ah64_rocketTable =
        [[0, 5]
        ,[500, 8]
        ,[750, 12]
        ,[1000, 15]
        ,[2000, 28]
        ,[3500, 75]
        ,[4500, 120]];
fza_ah64_weaponDebug = false;
fza_ah64_pylonsLastCheckMags = [];
fza_ah64_mousehorpos = 0.5;
fza_ah64_mousevertpos = 0.5;
fza_ah64_gunheat = 0;
fza_ah64_firekeypressed = 0;
fza_ah64_overallticker = 0;
fza_ah64_locktargstate = 0;
fza_ah64_irjammer = 0;
fza_ah64_salvofired = 0;
fza_ah64_mynum = 0;
fza_ah64_lastdir = 0;
fza_ah64_dps = 0;
fza_ah64_sideslip = 0;
fza_ah64_tiron = false;
fza_ah64_tadsLockCheckRunning = false;
fza_ah64_burst = 1;
fza_ah64_pfzcache = ["none", "none", [], 0];
fza_ah64_AseRWR = [];
fza_ah64_tsdmap = 0;
fza_ah64_Cscopelist = [];
fza_ah64_hducolor = [0.1, 1, 0, 1];
fza_ah64_introShownThisScenario = false;

//Scheduler arrays
fza_ah64_draw3Darray     = [fza_fnc_weaponTurretAim, fza_fnc_targetingPNVSControl, fza_fnc_targetingSched, fza_fnc_avionicsSlipIndicator, fza_fnc_navigationWaypointEta, fza_ihadss_fnc_ihadssController, fza_mpd_fnc_update, fza_ase_fnc_controller, fza_wca_fnc_update, fza_fire_fnc_update];
fza_ah64_draw3DarraySlow = [fza_fnc_weaponPylonCheckValid, fza_fire_fnc_HandleRearm, fza_aiCrew_fnc_floodlight];
fza_ah64_eachFrameArray  = [fza_sfmplus_fnc_coreUpdate, fza_systems_fnc_coreUpdate, fza_hellfire_fnc_aceController];
//Draw3d handler
fza_ah64_draw3Dhandler = addMissionEventHandler["Draw3d", {
    [0] call fza_fnc_coreDraw3Dscheduler;
}];
[0] spawn fza_ufd_fnc_update;

//EachFrame handler
fza_ah64_eachFrameHandler = addMissionEventHandler["EachFrame", {
    [0] call fza_fnc_coreEachFrameScheduler;
}];

#define OVERRIDE_ACTION(actn) \
    addUserActionEventHandler [actn, "Activate", {[actn, true] call fza_fnc_coreControlHandle}]; \
    addUserActionEventHandler [actn, "Deactivate", {[actn, false] call fza_fnc_coreControlHandle}];

OVERRIDE_ACTION("SwitchWeaponGrp1")
OVERRIDE_ACTION("SwitchWeaponGrp2")
OVERRIDE_ACTION("SwitchWeaponGrp3")
OVERRIDE_ACTION("SwitchWeaponGrp4")
OVERRIDE_ACTION("nextWeapon")
OVERRIDE_ACTION("prevWeapon")
OVERRIDE_ACTION("launchCM")
OVERRIDE_ACTION("vehLockTargets")