[
	"fza_ah64_enableCustomControls",
	"CHECKBOX",
	"Enable Custom Controls",
	"AH64D Apache",
	[true]
] call CBA_fnc_addSetting;

[
	"fza_ah64_rearmTime",
	"List",
	"Time taken to rearm",
	"AH64D Apache",
	[
		[0, 15, 30, 60, 120, 240],
		["Instant", "15 seconds", "30 seconds", "1 minute", "2 minutes", "4 minutes"],
		5
	]
] call CBA_fnc_addSetting;

[
	"fza_ah64_enableClickHelper",
	"CHECKBOX",
	"Enable Cockpit hints",
	"AH64D Apache",
	[true]
] call CBA_fnc_addSetting;

fza_ah64_fx_EH_Fired = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\calls\call_bi_fired.sqf";
fza_ah64_fx_30mm = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\effects_30mm.sqf";
fza_ah64_rocketalign = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\ffar_align2.sqf";
fza_ah64_hellfirealign = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\hellfire_align.sqf";
fza_ah64_hiderockets = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\calls\call_hidewpn.sqf";
fza_ah64_systemdamage = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\damage\system_dam.sqf";
fza_ah64_weapondamage = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\damage\weapon_dam.sqf";
fza_ah64_processdamage = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\damage\processor_dam.sqf";
fza_ah64_weaponfault = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\damage\gun_jam.sqf";
fza_ah64_ldrfcall = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\calls\call_ldrf.sqf";
fza_ah64_mousepos = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\calls\call_mousepos.sqf";
fza_ah64_hmdihadss = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\calls\call_ihadss.sqf";
fza_ah64_pfsched = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\calls\call_pfsched.sqf";
fza_ah64_rotordam = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\damage\dam_rotor.sqf";
fza_ah64_misguide = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\calls\call_missileg.sqf"; //NO MSL TRACKING WITHOUT IT
fza_ah64_setpb = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\fsetpitch.sqf";
fza_ah64_getpb = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\frotate.sqf";
fza_ah64_reldir = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\calls\call_reldir.sqf";
fza_ah64_turrets = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\calls\call_turrets.sqf";
fza_ah64_bladerot = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\calls\call_bladerot.sqf";
fza_ah64_pnvscontrol = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\calls\call_pnvs.sqf";
fza_ah64_targetcycle = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\calls\call_targeting.sqf";
fza_ah64_wepactionswitch = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\calls\call_was.sqf";
fza_ah64_velvect = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\calls\call_vvect.sqf";
fza_ah64_slipcheck = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\calls\call_slip.sqf";
fza_ah64_timetowp = compile preprocessFileLineNumbers "\fza_ah64_controls\scripting\calls\call_timetowp.sqf";
fza_ah64_perframe = {
	uiNamespace setVariable["fza_ah64_mapfake", (_this select 0)];
	((_this select 0) displayCtrl 3001) ctrlSetEventHandler["Draw", '[_this] call fza_ah64_pfsched'];
};

fza_ah64_rocketweps14 = ["fza_m261_1234_zoneE", "fza_m261_14", "fza_m261_14_zoneA", "fza_m261_14_zoneB", "fza_m261_14_zoneE"];
fza_ah64_rocketweps23 = ["fza_m261_1234_zoneE", "fza_m261_23", "fza_m261_23_zoneC", "fza_m261_23_zoneD", "fza_m261_23_zoneE"];
fza_ah64_rocketweps1 = ["fza_m261_1", "fza_m261_1_zone1", "fza_m261_1_zone2", "fza_m261_1_zone3"];
fza_ah64_rocketweps2 = ["fza_m261_2", "fza_m261_2_zone1", "fza_m261_2_zone2", "fza_m261_2_zone3"];
fza_ah64_rocketweps3 = ["fza_m261_3", "fza_m261_3_zone1", "fza_m261_3_zone2", "fza_m261_3_zone3"];
fza_ah64_rocketweps4 = ["fza_m261_4", "fza_m261_4_zone1", "fza_m261_4_zone2", "fza_m261_4_zone3"];
fza_ah64_hellfireweps1 = ["fza_agm114_1_4", "fza_agm114_1_ul", "fza_agm114_1_ur", "fza_agm114_1_ll", "fza_agm114_1_lr"];
fza_ah64_hellfireweps2 = ["fza_agm114_2_4", "fza_agm114_2_ul", "fza_agm114_2_ur", "fza_agm114_2_ll", "fza_agm114_2_lr"];
fza_ah64_hellfireweps3 = ["fza_agm114_3_4", "fza_agm114_3_ul", "fza_agm114_3_ur", "fza_agm114_3_ll", "fza_agm114_3_lr"];
fza_ah64_hellfireweps4 = ["fza_agm114_4_4", "fza_agm114_4_ul", "fza_agm114_4_ur", "fza_agm114_4_ll", "fza_agm114_4_lr"];

fza_ah64_mousehorpos = 0.5;
fza_ah64_mousevertpos = 0.5;
fza_ah64_laserstate = 0;
fza_ah64_gunheat = 0;
fza_ah64_firekeypressed = 0;
fza_ah64_fcrcscope = 0;
fza_ah64_hmdfsmode = "trans";
fza_ah64_overallticker = 0;
fza_ah64_pf_daytime = 0;
fza_ah64_misguidearray = [];
fza_ah64_curmisguide = 0;
fza_ah64_fire1arm = 0;
fza_ah64_fire2arm = 0;
fza_ah64_fireapuarm = 0;
fza_ah64_firepdisch = 0;
fza_ah64_firerdisch = 0;
fza_ah64_locktargstate = 0;
fza_ah64_irjammer = 0;
fza_ah64_rfjammer = 0;
fza_ah64_irjstate = 0;
fza_ah64_rfjstate = 0;
fza_ah64_irjon = 0;
fza_ah64_rfjon = 0;
fza_ah64_curflrln = 0;
fza_ah64_curchfln = 0;
fza_ah64_salvofired = 0;
fza_ah64_rocketsalvo = 1;
fza_ah64_flarecount = 30;
fza_ah64_chaffcount = 0;
fza_ah64_cmsel = 0;
fza_ah64_burst_limit = 10;
fza_ah64_ltype = "lobl.sqf";
fza_ah64_hfmode = objNull;
fza_ah64_remtsel = 0;
fza_ah64_mynum = 0;
fza_ah64_lastdir = 0;
fza_ah64_dps = 0;
fza_ah64_slip = 0;
fza_ah64_wptimhr = 0;
fza_ah64_wptim = 0;
fza_ah64_wptimtm = 0;
fza_ah64_wptimsm = 0;
fza_ah64_wpdistr = 0;
fza_ah64_tiron = false;
if (isNil "fza_ah64_desiglist") then {
	fza_ah64_desiglist = [];
};

fza_ah64_bweff = ppEffectCreate["colorCorrections", 1499];
fza_ah64_bweff ppEffectAdjust[0, 0, 0, [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]];
fza_ah64_bweff ppEffectCommit 0;
fza_ah64_bweff ppEffectEnable false;

if (isNil "fza_ah64_targetlist") then {
	fza_ah64_targetlist = [];
};
if (isNil "fza_ah64_mycurrenttarget") then {
	fza_ah64_mycurrenttarget = objNull;
};
fza_ah64_wheelbrake = 1;
fza_ah64_burst = 1;
fza_ah64_tsdsort = 0;
fza_ah64_tsdsortarray = ["all"];
fza_ah64_pfzcache = ["none", "none", [], 0];
publicvariable "fza_ah64_pfzcache";
if (isNil "fza_ah64_mis_ir") then {
	fza_ah64_mis_ir = ["M_R73_AA", "M_Strela_AA", "M_Igla_AA", "M_Stinger_AA", "M_Sidewinder_AA", "fza_fim92"];
};
if (isNil "fza_ah64_mis_rf") then {
	fza_ah64_mis_rf = ["M_9M311_AA"];
};
fza_ah64_aseautopage = 0;
fza_ah64_asethreats = [];
fza_ah64_threattracking = [];
fza_ah64_threatfiring = [];
fza_ah64_agmode = 0;
fza_ah64_mycurrenttarget = objNull;
fza_ah64_targlos = 0;
fza_ah64_currentpfz = [];
fza_ah64_pfz_count = 0;
fza_ah64_pfz1 = [];
fza_ah64_pfz2 = [];
fza_ah64_pfz3 = [];
fza_ah64_pfz4 = [];
fza_ah64_pfz5 = [];
fza_ah64_pfz6 = [];
fza_ah64_pfz7 = [];
fza_ah64_pfz8 = [];
fza_ah64_curwpnum = 0;
fza_ah64_curwp = [0, 0, 0];
fza_ah64_waypointdata = [getpos player];
fza_ah64_wpmarkers = [];
fza_ah64_rangesetting = 0.001; //1km
fza_ah64_fcrstate = 0;
fza_ah64_fcrlist = [];
fza_ah64_tsddisptargs = [];
fza_ah64_tsdmode = "nav";
fza_ah64_tsdmap = 0;
fza_ah64_dispfcrlist = [];
fza_ah64_estate = 0;
fza_ah64_turdir = 0;
fza_ah64_turelev = 0;
fza_ah64_pnvsdir = 0;
fza_ah64_pnvselev = 0.5;
fza_ah64_pylonelev = 0;
fza_ah64_pylonelev1 = 0;
fza_ah64_pylonelev2 = 0;
fza_ah64_pylonelev3 = 0;
fza_ah64_pylonelev4 = 0;
fza_ah64_guncontrol = 3;
fza_ah64_headdir = 0;
fza_ah64_headelev = 0;
fza_ah64_head1dir = 0;
fza_ah64_head1elev = 0;
fza_ah64_cmpressed = 0;
fza_ah64_nohelpers = 1;
fza_ah64_ihadssoff = 1;
fza_ah64_monocleinbox = 1;
fza_ah64_hducolor = [0.1, 1, 0, 1];
fza_ah64_schedarray = [fza_ah64_turrets, fza_ah64_pnvscontrol, fza_ah64_targetcycle, fza_ah64_slipcheck, fza_ah64_timetowp, fza_ah64_rotordam, fza_ah64_ldrfcall, fza_ah64_hmdihadss, fza_ah64_bladerot, fza_fnc_targetingUpdate, fza_fnc_engineGovernor, fza_fnc_mpdUpdateDisplays]; //disabled fza_ah64_cpg_controls//
fza_ah64_asemisarray = [];
fza_ah64_mapfaker = addMissionEventHandler["Draw3D", {
	[0] call fza_ah64_pfsched;
}];
fza_ah64_pfsstate = true;

//EXPERIMENTAL - RUN ONCE FOR PLAYER ONLY

_asetracker = [player] execvm "\fza_ah64_controls\scripting\page_ase.sqf";
_ufdtracker = [player] execvm "\fza_ah64_controls\scripting\ufd.sqf";
_targetscanner = [] execvm "\fza_ah64_controls\scripting\fcr_longbow.sqf";