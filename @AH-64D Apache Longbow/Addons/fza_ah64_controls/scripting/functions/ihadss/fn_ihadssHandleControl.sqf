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
	case "stow": {
		playsound "fza_ah64_monoclebox";
		[_heli] call fza_fnc_monocletoggle;
	};
};