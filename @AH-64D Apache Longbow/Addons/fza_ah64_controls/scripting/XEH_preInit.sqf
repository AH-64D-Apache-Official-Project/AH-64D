private _projName = "AH-64D Official Project";

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
	["Show vanilla targeting information (restart needed)", "Disabling this will hide vanilla targeting information (restart needed)"],
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
	"CHECKBOX",
	["Enable stabilator in SFM"],
	[_projName, "Flight model"],
	[true],
	0
] call CBA_fnc_addSetting;

[
	"fza_ah64_sfmPlusKeyboardOnly",
	"CHECKBOX",
	["Enable keyboard only mode in SFM"],
	[_projName, "Flight model"],
	[false],
  0
] call CBA_fnc_addSetting;

[
	"fza_ah64_ExperimentalFCR",
	"CHECKBOX",
	["Realistic FCR", "Enabling Realistic FCR should stop radar Targets from showing behind terrain, buildings & objects"],
	[_projName, "Fire Control Radar"],
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
fza_ah64_schedarray = [fza_fnc_weaponTurretAim, fza_fnc_targetingPNVSControl, fza_fnc_targetingSched, fza_fnc_avionicsSlipIndicator, fza_fnc_navigationWaypointEta, fza_fnc_ihadssDraw, fza_fnc_targetingUpdate, fza_fnc_mpdUpdateDisplays, fza_sfmplus_fnc_coreUpdate]; //BMK_fnc_coreUpdate
fza_ah64_introShownThisScenario = false;
fza_ah64_slowschedarray = [fza_fnc_targetingUpdate, fza_fnc_weaponPylonCheckValid, fza_fnc_fireHandleRearm, fza_aiCrew_fnc_floodlight];
fza_ah64_mapfaker = addMissionEventHandler["Draw3d", {
	[0] call fza_fnc_coreScheduler;
}];
[0] spawn fza_fnc_ufd;

["fza_engineFire", {
    params ["_heli", "_location"];
    [_heli] spawn fza_aiCrew_fnc_fireControl
}] call CBA_fnc_addEventHandler;

["fza_engineFire", {
    params ["_heli", "_location"];

	//If the effects are already present, don't overwrite
	if (_heli getVariable [format ["fza_ah64_fire_%1_fx", _location], []] isNotEqualTo []) exitWith {};
	private _side = [];
	private _sidef = [];
	private _mag = "";
	private _audio1 = "";
	switch _location do {
		case "right": {
			_side = [1.2, -0.8, -1.25];
			_sidef = [1.2, -0.6, -1.25];
			_mag = "fza_ah64_e2_fire";
			_audio1 = "fza_ah64_bt_engine2";
		};
		case "left": {
			_side = [-1, -0.8, -1.25];
			_sidef = [-1, -0.6, -1.25];
			_mag = "fza_ah64_e1_fire";
			_audio1 = "fza_ah64_bt_engine1";
		};
		case "apu": {
			_side = [0, -0.8, -1.25];
			_sidef = [0, 0.2, -1.25];
			_mag = "fza_ah64_apu_fire";
			_audio1 = "fza_ah64_bt_apu";
		};
	};

	private _smokefx = "#particlesource" createVehicleLocal getpos _heli;
	_smokefx attachto[_heli, [0, 0, 0]];

	private _firefx = "#particlesource" createVehicleLocal getpos _heli;
	_firefx attachto[_heli, [0, 0, 0]];

	_smokefx setParticleCircle[0, [0, 0, 0]];
	_smokefx setParticleRandom[0, [0.25, 0.25, 0], [0.2, 0.2, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
	_smokefx setParticleParams[["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 1], "", "Billboard", 1, 3, _side, [0, 0, 1], 0, 10, 7.9, 0.066, [2, 3, 4], [
		[0.1, 0.1, 0.1, 1],
		[0.2, 0.2, 0.2, 0.5],
		[0.3, 0.3, 0.3, 0]
	], [0.125], 1, 0, "", "", _heli];
	_smokefx setDropInterval 0.03;

	_firefx setParticleCircle[0, [0, 0, 0]];
	_firefx setParticleRandom[0.5, [0.25, 0.25, 0.1], [0, 0, 1], 0, 0.5, [0, 0, 0, 0], 0, 0];
	_firefx setDropInterval 0.01;
	_firefx setParticleParams[["\A3\data_f\ParticleEffects\Universal\Universal", 16, 10, 32, 1], "", "Billboard", 1, 0.2, _sidef, [0, 0, 0.5], 5, 1, 0.9, 0.3, [1], [
		[1, 1, 1, 1],
		[1, 1, 1, 0.75],
		[1, 1, 1, 0]
	], [0.5, 0.5, 0], 0.5, 0.5, "", "", _heli];

	_heli setVariable [format ["fza_ah64_fire_%1_fx", _location], [_smokefx, _firefx]];
}] call CBA_fnc_addEventHandler;

["fza_engineFireOut", {
    params ["_heli", "_location"];

	private _fx = _heli getVariable [format ["fza_ah64_fire_%1_fx", _location], []];
	if (count _fx != 2) exitWith {};

	detach (_fx # 0);
	detach (_fx # 1);

	deletevehicle (_fx # 0);
	deletevehicle (_fx # 1);

	_heli setVariable [format ["fza_ah64_fire_%1_fx", _location], []];
}] call CBA_fnc_addEventHandler;