/* ----------------------------------------------------------------------------
Function: fza_fnc_engineHandleControl

Description:
    Handles any engine-related cockpit controls.

Parameters:
	_heli - The helicopter to act on
	_system - the name of the system that the touched control belongs to
	_control - the name of the control that has been touched

Returns:
	Nothing

Examples:
	--- Code
    [_heli, "engine", "rtrbrake"] call engineHandleControl
	---

Author:
	Unknown, mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\engineConstants.h"
params ["_heli", "_system", "_control"];

switch(_control) do {
	case "apu": {
		if (_heli animationphase "plt_apu" < 1 && _heli animationphase "plt_batt" == 1) then {
			_heli animate["plt_apu", 1];
			["fza_ah64_apubutton", 0.1, "", 0, "", 0] spawn fza_fnc_playAudio;
			[_heli] execvm "\fza_ah64_controls\scripting\loops.sqf";
			[_heli, ["fza_ah64_apustart_3D", 200]] remoteExec["say3d"];
		} else {
			if (_heli animationphase "plt_apu" == 1) then {
				_heli animate["plt_apu", 0];
				["fza_ah64_apubutton", 0.1] spawn fza_fnc_playAudio;
				[_heli, ["fza_ah64_apustop_3D", 100]] remoteExec["say3d"];
			};
		};
	};
	case "power": {
	    if (_heli animationphase "plt_batt" < 1) then {
			_heli animate["plt_batt", 1];
			[_heli] execvm "\fza_ah64_controls\scripting\loops.sqf";
			["fza_ah64_battery", 0.1] spawn fza_fnc_playAudio;
		} else {
			_heli animate["plt_batt", 0];
			_heli animate["plt_anticollision", 0];
			_heli setCollisionLight false;
			_heli setPilotLight false;
			[_heli, ["fza_ah64_fake_3D", 10]] remoteExec["say3d"];
			["fza_ah64_battery", 0.1] spawn fza_fnc_playAudio;
		};
	};
	case "rtrbrake": {
		if (_heli animationphase "plt_rtrbrake" < 1) then {
			_heli animate["plt_rtrbrake", 1];
			["fza_ah64_switch_flip2", 0.1] spawn fza_fnc_playAudio;
		} else {
			_heli animate["plt_rtrbrake", 0];
			["fza_ah64_switch_flip2", 0.1] spawn fza_fnc_playAudio;
		};
	};
	case "e1start": {
		[_heli, 0, ENGINE_CONTROL_STARTER] spawn fza_fnc_engineSetPosition;
		["fza_ah64_switch_flip4", 0.1] spawn fza_fnc_playAudio;
	};
	case "e2start": {
		[_heli, 1, ENGINE_CONTROL_STARTER] spawn fza_fnc_engineSetPosition;
		["fza_ah64_switch_flip4", 0.1] spawn fza_fnc_playAudio;
	};
	case "e1off": {
		[_heli, 0, ENGINE_CONTROL_THROTTLE_OFF] spawn fza_fnc_engineSetPosition;
		["fza_ah64_throttle_idle", 0.1] spawn fza_fnc_playAudio;
	};
	case "e2off": {
		[_heli, 1, ENGINE_CONTROL_THROTTLE_OFF] spawn fza_fnc_engineSetPosition;
		["fza_ah64_throttle_idle", 0.1] spawn fza_fnc_playAudio;
	};
	case "e1idle": {
		[_heli, 0, ENGINE_CONTROL_THROTTLE_IDLE] spawn fza_fnc_engineSetPosition;
		["fza_ah64_throttle_idle", 0.1] spawn fza_fnc_playAudio;
	};
	case "e2idle": {
		[_heli, 1, ENGINE_CONTROL_THROTTLE_IDLE] spawn fza_fnc_engineSetPosition;
		["fza_ah64_throttle_idle", 0.1] spawn fza_fnc_playAudio;
	};
	case "e1fly": {
		[_heli, 0, ENGINE_CONTROL_THROTTLE_FLY] spawn fza_fnc_engineSetPosition;
		["fza_ah64_fake_3D", 0.1] spawn fza_fnc_playAudio;
	};
	case "e2fly": {
		[_heli, 1, ENGINE_CONTROL_THROTTLE_FLY] spawn fza_fnc_engineSetPosition;
		["fza_ah64_fake_3D", 0.1] spawn fza_fnc_playAudio;
	};
};