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
	Unknown, mattysmith22, BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\engineConstants.h"
params ["_heli", "_system", "_control"];

switch(_control) do {
	case "apu": {
		if (_heli animationphase "plt_apu" < 1 && _heli animationphase "plt_batt" == 1) then {
			_heli animateSource["plt_apu", 1];
			["fza_ah64_apubutton", 0.1, "", 0, "", 0] spawn fza_fnc_playAudio;
			[_heli] spawn fza_fnc_loops;
			[_heli, ["fza_ah64_apustart_3D", 200]] remoteExec["say3d"];
		} else {
			if (_heli animationphase "plt_apu" == 1) then {
				_heli animateSource["plt_apu", 0];

				//If either of the apache's engines are in a mode where they are using APU, turn it off.
				_heliData = _heli getVariable "fza_ah64_engineStates";
				(_heliData # 0) params ["_e1state"];
				(_heliData # 1) params ["_e2state"];
				if (_e1state in ENGINE_STATE_USING_STARTER) then {
					[_heli, 0, ENGINE_CONTROL_STARTER] spawn fza_fnc_engineSetPosition;
				};
				if (_e2state in ENGINE_STATE_USING_STARTER) then {
					[_heli, 1, ENGINE_CONTROL_STARTER] spawn fza_fnc_engineSetPosition;
				};
				[_heli, ["fza_ah64_apustop_3D", 100]] remoteExec["say3d"];
			};
		};
	};
	case "power": {
	    if (_heli animationphase "plt_batt" < 1) then {
			_heli animateSource["plt_batt", 1];
			[_heli] spawn fza_fnc_loops;
			["fza_ah64_battery", 0.1] spawn fza_fnc_playAudio;
		} else {
			_heli animateSource["plt_batt", 0];
			_heli animateSource["plt_anticollision", 0];
			_heli setCollisionLight false;
			_heli setPilotLight false;
			[_heli, ["fza_ah64_fake_3D", 10]] remoteExec["say3d"];
			["fza_ah64_battery", 0.1] spawn fza_fnc_playAudio;
		};
	};
	
	case "rtrbrake": {
		if (_heli animationphase "plt_rtrbrake" < 1) then {
			_heli animateSource["plt_rtrbrake", 1];
			["fza_ah64_switch_flip2", 0.1] spawn fza_fnc_playAudio;
		} else {
			_heli animateSource["plt_rtrbrake", 0];
			["fza_ah64_switch_flip2", 0.1] spawn fza_fnc_playAudio;
		};
	};

	//--------------------ENGINE 1--------------------//
	//Start Switch
	case "e1start": {
		//[_heli, 0, ENGINE_CONTROL_STARTER] spawn fza_fnc_engineSetPosition;
		[_heli, 0, "START"] spawn fza_fnc_sfmplusStartSwitch;
		["fza_ah64_switch_flip4", 0.1] spawn fza_fnc_playAudio;
	};
	//Power Lever
	case "e1off": {
		//[_heli, 0, ENGINE_CONTROL_THROTTLE_OFF] spawn fza_fnc_engineSetPosition;
		[_heli, 0, "OFF"] spawn fza_fnc_sfmplusPowerLever;
		["fza_ah64_throttle_idle", 0.1] spawn fza_fnc_playAudio;
	};
	case "e1idle": {
		//[_heli, 0, ENGINE_CONTROL_THROTTLE_IDLE] spawn fza_fnc_engineSetPosition;
		[_heli, 0, "IDLE"] spawn fza_fnc_sfmplusPowerLever;
		["fza_ah64_throttle_idle", 0.1] spawn fza_fnc_playAudio;
	};
	case "e1fly": {
		//[_heli, 0, ENGINE_CONTROL_THROTTLE_FLY] spawn fza_fnc_engineSetPosition;
		[_heli, 0, "FLY"] spawn fza_fnc_sfmplusPowerLever;
		["fza_ah64_fake_3D", 0.1] spawn fza_fnc_playAudio;
	};

	//--------------------ENGINE 2--------------------//
	//Start Switch
	case "e2start": {
		//[_heli, 1, ENGINE_CONTROL_STARTER] spawn fza_fnc_engineSetPosition;
		[_heli, 1, "START"] spawn fza_fnc_sfmplusStartSwitch;
		["fza_ah64_switch_flip4", 0.1] spawn fza_fnc_playAudio;
	};
	//Power Lever
	case "e2off": {
		//[_heli, 1, ENGINE_CONTROL_THROTTLE_OFF] spawn fza_fnc_engineSetPosition;
		[_heli, 1, "OFF"] spawn fza_fnc_sfmplusPowerLever;
		["fza_ah64_throttle_idle", 0.1] spawn fza_fnc_playAudio;
	};
	case "e2idle": {
		//[_heli, 1, ENGINE_CONTROL_THROTTLE_IDLE] spawn fza_fnc_engineSetPosition;
		[_heli, 1, "IDLE"] spawn fza_fnc_sfmplusPowerLever;
		["fza_ah64_throttle_idle", 0.1] spawn fza_fnc_playAudio;
	};
	case "e2fly": {
		//[_heli, 1, ENGINE_CONTROL_THROTTLE_FLY] spawn fza_fnc_engineSetPosition;
		[_heli, 1, "FLY"] spawn fza_fnc_sfmplusPowerLever;
		["fza_ah64_fake_3D", 0.1] spawn fza_fnc_playAudio;
	};
};