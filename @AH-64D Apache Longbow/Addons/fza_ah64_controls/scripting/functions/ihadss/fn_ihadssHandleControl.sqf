/* ----------------------------------------------------------------------------
Function: fza_fnc_ihadssHandleControl

Description:
    Handles any ihadss-related cockpit controls.

Parameters:
	_heli - The helicopter to act on
	_system - the name of the system that the touched control belongs to
	_control - the name of the control that has been touched

Returns:
	Nothing

Examples:
	--- Code
    [_heli, "ihadss", "brt"] call ihadssHandleControl
	---

Author:
	Unknown, mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\engineConstants.h"
params ["_heli", "_system", "_control"];

switch(_control) do {
	case "brt": {
		if (player == driver _heli) then {
			["fza_ah64_knob", 0.1] spawn fza_fnc_playAudio;
		} else {
			["fza_ah64_switch_flip2", 0.1] spawn fza_fnc_playAudio;
		};

		if (_heli animationphase "cpg_ihadss_brt" < 1 && player == gunner _heli) then {
			_heli animate["cpg_ihadss_brt", 1];
		} else {
			_heli animate["cpg_ihadss_brt", 0];
		};
		[_heli] call fza_fnc_ihadsstoggle;
	};
	case "stow": {
		["fza_ah64_monoclebox", 0.1] spawn fza_fnc_playAudio;
		[_heli] call fza_fnc_monocletoggle;
	};
};