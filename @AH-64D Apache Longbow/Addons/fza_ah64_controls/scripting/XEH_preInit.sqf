[
	"fza_ah64_showPopup",
	"CHECKBOX",
	["Show Popup Intro", "Show popup when the player gets into an Apache"],
	["AH-64D Official Project", "UI"],
	true
] call CBA_fnc_addSetting;

[
	"fza_ah64_headTrackAllowCursorMove",
	"CHECKBOX",
	"Allow cursor movement while in head tracking mode",
	["AH-64D Official Project", "Control"],
	[true],
	0
] call CBA_fnc_addSetting;

[
	"fza_ah64_headTrackSensitivity",
	"SLIDER",
	"Head tracking mode cursor sensitivity",
	["AH-64D Official Project", "Control"],
	[0, 1, 0.5, 2],
	0
] call CBA_fnc_addSetting;

[
	"fza_ah64_enableClickHelper",
	"CHECKBOX",
	["Enable cockpit hints", "Disabling this will hide the Cockpit hints"],

	["AH-64D Official Project", "UI"],
	[true]
] call CBA_fnc_addSetting;

[
	"fza_ah64_vanillaTargetingEnable",
	"CHECKBOX",
	["Show vanilla targeting information (restart needed)", "Disabling this will hide vanilla targeting information (restart needed)"],
	["AH-64D Official Project", "UI"],
	[true],
	0,
	{
		profileNamespace setVariable ["fza_ah64_enableTargeting", [0, 1] select _this];
		saveProfileNamespace;
	}
] call CBA_fnc_addSetting;

[
	"fza_ah64_sfmPlusStabilatorEnabled",
	"CHECKBOX",
	["Enable stabilator", "Disclaimer: All crew need to disable this funtion to turn off"],
	["AH-64D Official Project", "Flight model"],
	[true],
	0
] call CBA_fnc_addSetting;

[
	"fza_ah64_ExperimentalFCR",
	"CHECKBOX",
	["Realistic FCR", "Enabling Realistic FCR should stop radar Targets from showing behind terrain, buildings & objects"],
	["AH-64D Official Project", "Fire Control Radar"],
	[true],
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
fza_ah64_rfjammer = 0;
fza_ah64_salvofired = 0;
fza_ah64_mynum = 0;
fza_ah64_lastdir = 0;
fza_ah64_dps = 0;
fza_ah64_slip = 0;
fza_ah64_wptimhr = 0;
fza_ah64_wptim = 0;
fza_ah64_tiron = false;
fza_ah64_wptimtm = 0;
fza_ah64_wptimsm = 0;
fza_ah64_wpdistr = 0;
fza_ah64_targetlist = [];
fza_ah64_mycurrenttarget = objNull;
fza_ah64_tadsLockCheckRunning = false;
fza_ah64_burst = 1;
fza_ah64_pfzcache = ["none", "none", [], 0];
fza_ah64_asethreats = [];
fza_ah64_asethreatsdraw = [];
fza_ah64_threattracking = [];
fza_ah64_threatfiring = [];
fza_ah64_mycurrenttarget = objNull;
fza_ah64_fcrlist = [];
fza_ah64_tsdmap = 0;
fza_ah64_Cscopelist = [];
fza_ah64_hducolor = [0.1, 1, 0, 1];
fza_ah64_schedarray = [fza_fnc_weaponTurretAim, fza_fnc_targetingPNVSControl, fza_fnc_targetingSched, fza_fnc_avionicsSlipIndicator, fza_fnc_navigationWaypointEta, fza_fnc_ihadssDraw, fza_fnc_targetingUpdate, fza_fnc_engineGovernor, fza_fnc_mpdUpdateDisplays, fza_fnc_sfmplusUpdate];
fza_ah64_introShownThisScenario = false;
fza_ah64_slowschedarray = [fza_fnc_targetingUpdate, fza_fnc_weaponPylonCheckValid];
fza_ah64_mapfaker = addMissionEventHandler["Draw3d", {
	[0] call fza_fnc_coreScheduler;
}];

//apache unique databases
fza_ah64_ada_units = ["vme_PLA_DK9","VME_PLA_HQ64","VME_PLA_HQ7","VME_PLA_PGZ04","VME_PLA_EQ2050_AA","RHS_Stinger_AA_pod_Base","SAM_System_01_base_F","SAM_System_03_base_F",
"Radar_System_01_base_F","SAM_System_02_base_F","AAA_System_01_base_F","RHS_ZU23_base","rhs_Igla_AA_pod_Base","AA_01_base_F","Radar_System_02_base_F","SAM_System_04_base_F",
"RR_PGZ_04_ADS_SP_AA","VME_PLA_ADS_Base","I_LT_01_scout_F","I_LT_01_AA_F","O_APC_Tracked_02_AA_F","O_T_APC_Tracked_02_AA_ghex_F","rhs_zsutank_base","LOP_ZSU234_base",
"B_APC_Tracked_01_AA_F","B_T_APC_Tracked_01_AA_F","RHS_Ural_Zu23_Base","UK3CB_MTLB_Zu23","UK3CB_V3S_Zu23","UK3CB_Hilux_ZU23","LT_01_scout_base_F"];
fza_ah64_mis_ir = ["M_R73_AA","M_Strela_AA","M_Igla_AA","M_Stinger_AA","M_Sidewinder_AA","fza_fim92","Missile_AGM_01_F","ammo_Missile_rim116","ammo_Missile_BIM9X","M_Air_AA","M_Air_AA_MI02","M_Air_AA_MI06","Missile_AA_04_F","Missile_AGM_02_F","Missile_AA_03_F","rhs_fim92_mag","rhs_mag_9k38_rocket","rhs_mag_9k32_rocket","M_Titan_AA"];
fza_ah64_mis_rf = ["M_9M311_AA","ammo_Missile_s750","ammo_Missile_rim162","ammo_Missile_mim145","ammo_Missile_AMRAAM_D","ammo_Missile_AMRAAM_C","ammo_Missile_AA_R77","ammo_Missile_AA_R73","M_Zephyr","M_Titan_AA_long","M_Titan_AA_static"];

[0] spawn fza_fnc_ufd;