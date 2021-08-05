/* ----------------------------------------------------------------------------
Function: fza_fnc_lightHandleControl

Description:
    Handles any light-related cockpit controls.

Parameters:
	_heli - The helicopter to act on
	_system - the name of the system that the touched control belongs to
	_control - the name of the control that has been touched

Returns:
	Nothing

Examples:
	--- Code
    [_heli, "light", "floodlight"] call_lightHandleControl
	---

Author:
	Unknown, mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\selections.h"
params ["_heli", "_system", "_control"];

switch (_control) do {
	case "floodlight": {
		if (!(isLightOn [_heli,[0]]) && _heli animationphase "plt_batt" > 0.5) then {
			_heli setObjectTextureGlobal [SEL_IN_BACKLIGHT, "\fza_ah64_us\tex\in\dlt.paa"];
			_heli setobjecttextureGlobal [SEL_IN_BACKLIGHT2, "\fza_ah64_us\tex\in\pushbut.paa"];

			[_heli, true] call fza_fnc_lightSetCockpitLight;

		} else {
			_heli setobjecttextureGlobal [SEL_IN_BACKLIGHT, ""];
			_heli setobjecttextureGlobal [SEL_IN_BACKLIGHT2, ""];

			[_heli, false] call fza_fnc_lightSetCockpitLight;

		};
		["fza_ah64_button_rotary", 0.1] spawn fza_fnc_playAudio;
	};
	case "anticollision": {
		if (_heli animationphase "plt_anticollision" < 1 && _heli animationphase "plt_batt" > 0.5) then {
			_heli animateSource["plt_anticollision", 1];
			_heli setCollisionLight true;
		} else {
			_heli animateSource["plt_anticollision", 0];
			_heli setCollisionLight false;
		};
        ["fza_ah64_switch_flip3", 0.1] spawn fza_fnc_playAudio;
	};
};