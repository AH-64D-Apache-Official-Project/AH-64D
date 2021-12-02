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

#define COCKPIT_CONTROL(pilot_mempoint, gunner_mempoint, system, system_name, control, sensitivity, control_name) [pilot_mempoint, gunner_mempoint, #system, #control, sensitivity, control_name]
#define COCKPIT_CONTROL_SEP ,
private _controls =  [	//Schema of Pilot memory point, Gunner memory point, system, control, sensitivity, description]
#include "\fza_ah64_controls\headers\controls.h"
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