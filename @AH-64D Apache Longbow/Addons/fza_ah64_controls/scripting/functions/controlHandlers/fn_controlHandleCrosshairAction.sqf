/* ----------------------------------------------------------------------------
Function: fza_fnc_controlHandleCrosshairAction

Description:
    Called when the action crosshair button is pressed.

Parameters:
	_heli - The apache helicopter to handle a click for

Returns:
	Nothing

Examples:
	--- Code
	// When you want to click what the player is looking at.
    [_heli] call fza_fnc_controlHandleCrosshairAction
	---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli"];


if (player != driver _heli && player != gunner _heli) exitWith {};

private _controls = [_heli] call fza_fnc_coreGetObjectsLookedAt;
if (_controls isEqualTo []) exitWith {};

//If there are multiple controls in the range, make sure we use the closest one
if(count _controls > 1) then {
	_controls = [_controls, [], {_x # 6}, "ASCEND"] call BIS_fnc_sortBy;
};

(_controls # 0) params ["", "", "_system", "_control"];

private _clickSound = ["none"];

switch (_system) do {
	case "lmpd";
	case "rmpd" : {
		_clickSound = [_heli, _system, _control] call fza_fnc_mpdHandleControl;
	};
	case "fire": {
		_clickSound = [_heli, _system, _control] call fza_fnc_fireHandleControl;
	};
	case "door": {
		if (_control == "handle") then {
			if (player == gunner _heli) then {
				[_heli] spawn fza_fnc_doortoggleG;
			} else {
				[_heli] spawn fza_fnc_doortogglep;
			};
		}
	};
	case "engine": {
		[_heli, _system, _control] call fza_fnc_engineHandleControl;
	};
	case "ihadss": {
		_clickSound = [_heli, _system, _control] call fza_fnc_ihadssHandleControl;
	};
	case "pnvs": {
		if (_control == "daynight") then {
			_heli setVariable ["fza_ah64_ihadss_pnvs_day", !(_heli getVariable "fza_ah64_ihadss_pnvs_day")];
			["fza_ah64_knob", 0.1] spawn fza_fnc_playAudio;
		}
	};
	case "nvs": {
		private _nvsSwitch = (if (driver _heli == player) then {"plt_nvsmode"} else {"cpg_nvsmode"});
		if (_control == "mode") then {
			if (_heli animationphase _nvsSwitch < 1) then {
				_heli animateSource[_nvsSwitch, 1];
				_heli setVariable ["fza_ah64_ihadss_pnvs_cam", true];
			} else {
				_heli animateSource[_nvsSwitch, 0];
				_heli setVariable ["fza_ah64_ihadss_pnvs_cam", false];
			};
			["fza_ah64_switch_flip3", 0.1] spawn fza_fnc_playAudio;
		}
	};
	case "light": {
		_clickSound = [_heli, _system, _control] call fza_fnc_lightHandleControl;
	};
};

// I haven't gotten these to work reliably enough to make it worth adding. Leaving here just in case that changes
// - mattysmith22

/*

//ownship [0.18,4.1,-0.735]
private _ownship = _heli modelToWorldVisual(_heli selectionposition "ctrlref_rmpd_ownship");
if (player == gunner _heli) then {
    _ownship = _heli modelToWorldVisual(_heli selectionposition "ctrlref_g_rmpd_ownship");
};
_ownship = worldtoscreen _ownship;
if (count _ownship < 2) then {
    _ownship = [0, 0];
};