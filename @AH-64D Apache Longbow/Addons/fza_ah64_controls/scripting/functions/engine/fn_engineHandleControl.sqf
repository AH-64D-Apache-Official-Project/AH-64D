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
			[_heli] spawn fza_fnc_fxLoops;
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
			[_heli] spawn fza_fnc_fxLoops;
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
		private _startSwitchToStart = [_heli, 0] call fza_sfmplus_fnc_interactStartSwitch;
		if (_startSwitchToStart) then {
			_heli animateSource ["plt_eng1_start", [0, 2] select (_heli animationSourcePhase "plt_eng1_start" != 0)]
		};
		["fza_ah64_switch_flip4", 0.1] spawn fza_fnc_playAudio;
	};
	//Power Lever
	case "e1off": {
		[_heli, 0, "OFF"] spawn fza_sfmplus_fnc_interactPowerLever;

		["fza_ah64_throttle_idle", 0.1] spawn fza_fnc_playAudio;
	};
	case "e1idle": {
		[_heli, 0, "IDLE"] spawn fza_sfmplus_fnc_interactPowerLever;

		["fza_ah64_throttle_idle", 0.1] spawn fza_fnc_playAudio;
	};
	case "e1fly": {
		private _eng2State       = _heli getVariable "fza_sfmplus_engState" select 1;
		private _eng2PwrLvrState = _heli getVariable "fza_sfmplus_engPowerLeverState" select 1;
		//Allow the eng 1 power lever to be advanced individually when the opposite engine
		//is off OR when the opposite engine is on w/ it's power lever at fly
		if (_eng2State == "OFF" || (_eng2State == "ON" && _eng2PwrLvrState == "FLY")) then {
			[_heli, 0, "FLY"] spawn fza_sfmplus_fnc_interactPowerLever;
		};
		//Advance both power levers to fly together when the opposite engine is on and its
		//power lever is at idle
		if (_eng2State == "ON" && _eng2PwrLvrState == "IDLE") then {
			[_heli, 0, "FLY"] spawn fza_sfmplus_fnc_interactPowerLever;
			[_heli, 1, "FLY"] spawn fza_sfmplus_fnc_interactPowerLever;
		};
		
		["fza_ah64_fake_3D", 0.1] spawn fza_fnc_playAudio;
	};
	
	//--------------------ENGINE 2--------------------//	
	//Start Switch
	case "e2start": {
		private _startSwitchToStart = [_heli, 1] call fza_sfmplus_fnc_interactStartSwitch;
		if (_startSwitchToStart) then {
			_heli animateSource ["plt_eng2_start", [0, 2] select (_heli animationSourcePhase "plt_eng2_start" != 0)]
		};
		["fza_ah64_switch_flip4", 0.1] spawn fza_fnc_playAudio;
	};
	//Power Lever
	case "e2off": {
		[_heli, 1, "OFF"] spawn fza_sfmplus_fnc_interactPowerLever;

		["fza_ah64_throttle_idle", 0.1] spawn fza_fnc_playAudio;
	};
	case "e2idle": {
		[_heli, 1, "IDLE"] spawn fza_sfmplus_fnc_interactPowerLever;

		["fza_ah64_throttle_idle", 0.1] spawn fza_fnc_playAudio;
	};
	case "e2fly": {
		private _eng1State       = _heli getVariable "fza_sfmplus_engState" select 0;
		private _eng1PwrLvrState = _heli getVariable "fza_sfmplus_engPowerLeverState" select 0;
		//Allow the eng 1 power lever to be advanced individually when the opposite engine
		//is off OR when the opposite engine is on w/ it's power lever at fly
		if (_eng1State == "OFF" || (_eng1State == "ON" && _eng1PwrLvrState == "FLY")) then {
			[_heli, 1, "FLY"] spawn fza_sfmplus_fnc_interactPowerLever;
		};
		//Advance both power levers to fly together when the opposite engine is on and its
		//power lever is at idle
		if (_eng1State == "ON" && _eng1PwrLvrState == "IDLE") then {
			[_heli, 0, "FLY"] spawn fza_sfmplus_fnc_interactPowerLever;
			[_heli, 1, "FLY"] spawn fza_sfmplus_fnc_interactPowerLever;
		};
		
		["fza_ah64_fake_3D", 0.1] spawn fza_fnc_playAudio;
	};
};