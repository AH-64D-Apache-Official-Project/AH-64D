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
			_heli setobjecttexture [SEL_IN_BACKLIGHT, "\fza_ah64_us\tex\in\dlt.paa"];
			_heli setobjecttexture [SEL_IN_BACKLIGHT2, "\fza_ah64_us\tex\in\pushbut.paa"];
				
			//spawn ai when no gunner
			if (isnull(_heli turretUnit [0])) then {
				_ai = group player createUnit ["B_RangeMaster_F", [0,0,0], [], 0, "NONE"];
				hideObject _ai;
				_ai moveIngunner _heli;
				(vehicle player turretUnit [0]) action ["searchlighton",vehicle player];
				_heli deleteVehicleCrew gunner _heli;
			};
			
			(vehicle player turretUnit [0]) action ["searchlighton",vehicle player];
		} else {
			_heli setobjecttexture [SEL_IN_BACKLIGHT, ""];
			_heli setobjecttexture [SEL_IN_BACKLIGHT2, ""];

			//spawn ai when no gunner
			if (isnull(_heli turretUnit [0])) then {
				_ai = group player createUnit ["B_RangeMaster_F", [0,0,0], [], 0, "NONE"];
				hideObject _ai;
				_ai moveIngunner _heli;
				(vehicle player turretUnit [0]) action ["searchlightoff",vehicle player];
				_heli deleteVehicleCrew gunner _heli;
			};

			(vehicle player turretUnit [0]) action ["searchlightoff",vehicle player];
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