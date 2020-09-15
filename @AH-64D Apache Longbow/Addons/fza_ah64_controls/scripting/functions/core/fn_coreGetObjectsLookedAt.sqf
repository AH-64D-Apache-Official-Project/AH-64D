/* ----------------------------------------------------------------------------
Function: fza_fnc_coreGetObjectsLookedAt

Description:
    Retrieves information about each object that is looked at by the user.

	Works for both pilot and gunner seats, and uses preconfigured sensitivity to
	determine the zone it works for.

Parameters:
	_heli - The apache helicopter to get information from [Unit].

Returns:
	2d array, an array for each control that is in range in the format of:
	    [Pilot memory point, Gunner memory point, system, control, sensitivity, description, distance]

Examples:
	--- Code
	// Player not looking at anything
    _data = [_heli] call fza_fnc_coreGetObjectsLookedAt
	// _data = []

	// Player looking at the L1 button on the right MPD
    _data = [_heli] call fza_fnc_coreGetObjectsLookedAt
	// _data = [["ctrlref_rmpd_l1", "ctrlref_g_rmpd_l1", "rmpd", "l1", 0.015, "Right MPD L1"]]
	---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli"];

private _controls =  [
	//Schema of Pilot memory point, Gunner memory point, system, control, sensitivity, description]
	["ctrlref_rmpd_l1", "ctrlref_g_rmpd_l1", "rmpd", "l1", 0.015, "Right MPD L1"],
	["ctrlref_rmpd_l2", "ctrlref_g_rmpd_l2", "rmpd", "l2", 0.015, "Right MPD L2"],
	["ctrlref_rmpd_l3", "ctrlref_g_rmpd_l3", "rmpd", "l3", 0.015, "Right MPD L3"],
	["ctrlref_rmpd_l4", "ctrlref_g_rmpd_l4", "rmpd", "l4", 0.015, "Right MPD L4"],
	["ctrlref_rmpd_l5", "ctrlref_g_rmpd_l5", "rmpd", "l5", 0.015, "Right MPD L5"],
	["ctrlref_rmpd_l6", "ctrlref_g_rmpd_l6", "rmpd", "l6", 0.015, "Right MPD L6"],
	["ctrlref_rmpd_b1", "ctrlref_g_rmpd_b1", "rmpd", "b1", 0.015, "Right MPD B1"],
	["ctrlref_rmpd_b2", "ctrlref_g_rmpd_b2", "rmpd", "b2", 0.015, "Right MPD B2"],
	["ctrlref_rmpd_b3", "ctrlref_g_rmpd_b3", "rmpd", "b3", 0.015, "Right MPD B3"],
	["ctrlref_rmpd_b4", "ctrlref_g_rmpd_b4", "rmpd", "b4", 0.015, "Right MPD B4"],
	["ctrlref_rmpd_b5", "ctrlref_g_rmpd_b5", "rmpd", "b5", 0.015, "Right MPD B5"],
	["ctrlref_rmpd_b6", "ctrlref_g_rmpd_b6", "rmpd", "b6", 0.015, "Right MPD B6"],
	["ctrlref_rmpd_r1", "ctrlref_g_rmpd_r1", "rmpd", "r1", 0.015, "Right MPD R1"],
	["ctrlref_rmpd_r2", "ctrlref_g_rmpd_r1", "rmpd", "r2", 0.015, "Right MPD R2"],
	["ctrlref_rmpd_r3", "ctrlref_g_rmpd_r3", "rmpd", "r3", 0.015, "Right MPD R3"],
	["ctrlref_rmpd_r4", "ctrlref_g_rmpd_r4", "rmpd", "r4", 0.015, "Right MPD R4"],
	["ctrlref_rmpd_r5", "ctrlref_g_rmpd_r5", "rmpd", "r5", 0.015, "Right MPD R5"],
	["ctrlref_rmpd_r6", "ctrlref_g_rmpd_r6", "rmpd", "r6", 0.015, "Right MPD R6"],
	["ctrlref_rmpd_t1", "ctrlref_g_rmpd_t1", "rmpd", "t1", 0.015, "Right MPD T1"],
	["ctrlref_rmpd_t2", "ctrlref_g_rmpd_t1", "rmpd", "t2", 0.015, "Right MPD T2"],
	["ctrlref_rmpd_t3", "ctrlref_g_rmpd_t3", "rmpd", "t3", 0.015, "Right MPD T3"],
	["ctrlref_rmpd_t4", "ctrlref_g_rmpd_t4", "rmpd", "t4", 0.015, "Right MPD T4"],
	["ctrlref_rmpd_t5", "ctrlref_g_rmpd_t5", "rmpd", "t5", 0.015, "Right MPD T5"],
	["ctrlref_rmpd_t6", "ctrlref_g_rmpd_t6", "rmpd", "t6", 0.015, "Right MPD T6"],
	["ctrlref_rmpd_fcr", "ctrlref_g_rmpd_fcr", "rmpd", "fcr", 0.015, "Right MPD FCR"],
	["ctrlref_rmpd_wpn", "ctrlref_g_rmpd_wpn", "rmpd", "wpn", 0.015, "Right MPD WPN"],
	["ctrlref_rmpd_tsd", "ctrlref_g_rmpd_tsd", "rmpd", "tsd", 0.015, "Right MPD TSD"],
	["ctrlref_rmpd_m", "ctrlref_g_rmpd_m", "rmpd", "m", 0.015, "Right MPD Menu"],
	["ctrlref_rmpd_brt", "", "rmpd", "brt", 0.015, "MPD Brightness"],

	["ctrlref_lmpd_l1", "ctrlref_g_lmpd_l1", "lmpd", "l1", 0.015, "Left MPD L1"],
	["ctrlref_lmpd_l2", "ctrlref_g_lmpd_l2", "lmpd", "l2", 0.015, "Left MPD L2"],
	["ctrlref_lmpd_l3", "ctrlref_g_lmpd_l3", "lmpd", "l3", 0.015, "Left MPD L3"],
	["ctrlref_lmpd_l4", "ctrlref_g_lmpd_l4", "lmpd", "l4", 0.015, "Left MPD L4"],
	["ctrlref_lmpd_l5", "ctrlref_g_lmpd_l5", "lmpd", "l5", 0.015, "Left MPD L5"],
	["ctrlref_lmpd_l6", "ctrlref_g_lmpd_l6", "lmpd", "l6", 0.015, "Left MPD L6"],
	["ctrlref_lmpd_b1", "ctrlref_g_lmpd_b1", "lmpd", "b1", 0.015, "Left MPD B1"],
	["ctrlref_lmpd_b2", "ctrlref_g_lmpd_b2", "lmpd", "b2", 0.015, "Left MPD B2"],
	["ctrlref_lmpd_b3", "ctrlref_g_lmpd_b3", "lmpd", "b3", 0.015, "Left MPD B3"],
	["ctrlref_lmpd_b4", "ctrlref_g_lmpd_b4", "lmpd", "b4", 0.015, "Left MPD B4"],
	["ctrlref_lmpd_b5", "ctrlref_g_lmpd_b5", "lmpd", "b5", 0.015, "Left MPD B5"],
	["ctrlref_lmpd_b6", "ctrlref_g_lmpd_b6", "lmpd", "b6", 0.015, "Left MPD B6"],
	["ctrlref_lmpd_r1", "ctrlref_g_lmpd_r1", "lmpd", "r1", 0.015, "Left MPD R1"],
	["ctrlref_lmpd_r2", "ctrlref_g_lmpd_r1", "lmpd", "r2", 0.015, "Left MPD R2"],
	["ctrlref_lmpd_r3", "ctrlref_g_lmpd_r3", "lmpd", "r3", 0.015, "Left MPD R3"],
	["ctrlref_lmpd_r4", "ctrlref_g_lmpd_r4", "lmpd", "r4", 0.015, "Left MPD R4"],
	["ctrlref_lmpd_r5", "ctrlref_g_lmpd_r5", "lmpd", "r5", 0.015, "Left MPD R5"],
	["ctrlref_lmpd_r6", "ctrlref_g_lmpd_r6", "lmpd", "r6", 0.015, "Left MPD R6"],
	["ctrlref_lmpd_t1", "ctrlref_g_lmpd_t1", "lmpd", "t1", 0.015, "Left MPD T1"],
	["ctrlref_lmpd_t2", "ctrlref_g_lmpd_t1", "lmpd", "t2", 0.015, "Left MPD T2"],
	["ctrlref_lmpd_t3", "ctrlref_g_lmpd_t3", "lmpd", "t3", 0.015, "Left MPD T3"],
	["ctrlref_lmpd_t4", "ctrlref_g_lmpd_t4", "lmpd", "t4", 0.015, "Left MPD T4"],
	["ctrlref_lmpd_t5", "ctrlref_g_lmpd_t5", "lmpd", "t5", 0.015, "Left MPD T5"],
	["ctrlref_lmpd_t6", "ctrlref_g_lmpd_t6", "lmpd", "t6", 0.015, "Left MPD T6"],
	["ctrlref_lmpd_wpn", "ctrlref_g_lmpd_wpn", "lmpd", "wpn", 0.015, "Left MPD WPN"],
	["ctrlref_lmpd_m", "ctrlref_g_lmpd_m", "lmpd", "m", 0.015, "Left MPD Menu"],
	["ctrlref_lmpd_brt", "", "lmpd", "brt", 0.015, "MPD Brightness"],

	["ctrlref_p_fe1", "ctrlref_g_fe1", "fire", "fe1", 0.03, "Fire Engine 1"],
	["ctrlref_p_fapu", "ctrlref_g_fapu", "fire", "fapu", 0.03, "Fire APU"],
	["ctrlref_p_fe2", "ctrlref_g_fe2", "fire", "fe2", 0.03, "Fire Engine 2"],
	["ctrlref_p_fbp", "ctrlref_g_fbp", "fire", "fbp", 0.03, "Fire Bottle Primary"],
	["ctrlref_p_fbr", "ctrlref_g_fbr", "fire", "fbr", 0.03, "Fire Bottle Reserve"],
	["ctrlref_p_swfiretst", "ctrlref_g_swfiretst", "fire", "test", 0.03, "Fire Test"],

	["ctrlref_p_doorhandle", "ctrlref_g_doorhandle", "door", "handle", 0.03, "Pilot Door Handle"],

	["ctrlref_p_ihadss_brt", "ctrlref_g_ihadss_brt", "ihadss", "brt", 0.03, "IHADSS Brightness"],
	["ctrlref_p_monocle", "ctrlref_g_monocle", "ihadss", "stow", 0.1, "IHADSS Monocle"],

	["ctrlref_p_apu", "", "engine", "apu", 0.03, "APU Toggle"],
	["ctrlref_p_mstrign", "", "engine", "power", 0.03, "Battery Toggle"],
	["ctrlref_p_rtrbrake", "", "engine", "rtrbrake", 0.03, "Rotor Brake"],
	["ctrlref_p_e1start", "", "engine", "e1start", 0.03, "Engine 1 Start"],
	["ctrlref_p_e1off", "", "engine", "e1off", 0.03, "Engine 1 Off"],
	["ctrlref_p_e1idle", "", "engine", "e1idle", 0.03, "Engine 1 Idle"],
	["ctrlref_p_e1fly", "", "engine", "e1fly", 0.03, "Engine 1 Fly"],
	["ctrlref_p_e2start", "", "engine", "e2start", 0.03, "Engine 2 Start"],
	["ctrlref_p_e2off", "", "engine", "e2off", 0.03, "Engine 2 Off"],
	["ctrlref_p_e2idle", "", "engine", "e2idle", 0.03, "Engine 2 Idle"],
	["ctrlref_p_e2fly", "", "engine", "e2fly", 0.03, "Engine 2 Fly"],

	["ctrlref_p_pnvs_dn", "ctrlref_g_pnvs_dn", "pnvs", "daynight", 0.03, "PNVS Day / Night Toggle"],
	["nvs_mode_sw", "nvs_mode_swg", "nvs", "mode", 0.03, "NVS Mode"],

	["plt_flood", "cpg_flood", "light", "floodlight", 0.03, "Floodlight"],
	["plt_anticollision", "", "light", "anticollision", 0.03, "Anti-Collision Light"]
];
_controls = _controls apply {
	_x params ["_pilotPos", "_gunnerPos", "_systemName", "_eventName", "_sensitivity", "_description"];
	private _point = [];
	if(driver _heli == player && _pilotPos != "") then {
		_point = _heli modelToWorldVisual (_heli selectionposition _pilotPos);
	};
	if(gunner _heli == player && _gunnerPos != "") then {
		_point = _heli modelToWorldVisual (_heli selectionposition _gunnerPos);
	};
	_point =  (worldToScreen _point);
	_distance = if (_point isEqualTo []) then {1000} else {_point distance [fza_ah64_mousehorpos, fza_ah64_mousevertpos]};
	[_pilotPos, _gunnerPos, _systemName, _eventName, _sensitivity, _description, _distance];
};
_controls select {
	_x params ["", "", "", "", "_sensitivity", "", "_distance"];
	_distance < _sensitivity;
};