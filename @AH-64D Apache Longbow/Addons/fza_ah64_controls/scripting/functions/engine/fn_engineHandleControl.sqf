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

private _apuBtnOn     = _heli getVariable "fza_systems_apuBtnOn";
private _battSwitchOn = _heli getVariable "fza_systems_battSwitchOn";
private _battBusOn    = _heli getVariable "fza_systems_battBusOn";

switch(_control) do {
	case "apu": {
			if (!_apuBtnOn && _battBusOn) then {
			[_heli] call fza_systems_fnc_interactAPUButton;
			["fza_ah64_apubutton", 0.1, "", 0, "", 0] spawn fza_fnc_playAudio;
			[_heli] spawn fza_fnc_fxLoops;
			[_heli, ["fza_ah64_apustart_3D", 200]] remoteExec["say3d"];
		} else {
			if (_apuBtnOn) then {
				[_heli] call fza_systems_fnc_interactAPUButton;
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
		if (_battSwitchOn) then {
			[_heli] call fza_systems_fnc_interactBattSwitch;
			[_heli] spawn fza_fnc_fxLoops;
			["fza_ah64_battery", 0.1] spawn fza_fnc_playAudio;
		} else {
			[_heli] call fza_systems_fnc_interactBattSwitch;
			[_heli, "fza_ah64_anticollision", false] call fza_fnc_animSetValue;
			_heli setCollisionLight false;
			_heli setPilotLight false;
			[_heli, ["fza_ah64_fake_3D", 10]] remoteExec["say3d"];
			["fza_ah64_battery", 0.1] spawn fza_fnc_playAudio;
		};
	};
	
	case "rtrbrake": {
		[_heli, "fza_ah64_rtrbrake", !(_heli getVariable "fza_ah64_rtrbrake")] call fza_fnc_animSetValue;
		["fza_ah64_switch_flip2", 0.1] spawn fza_fnc_playAudio;
	};

	//--------------------ENGINE 1--------------------//
	//Start Switch
	case "e1start": {
		private _eng1state = fza_simvars_e1State;
		[_heli, 0] call fza_fnc_fmStartSwitch;
		[_heli,_eng1state] spawn {
			params ["_heli","_eng1state"];
			if (_eng1state == "OFF") then {
				_heli animateSource ["plt_eng1_start", 1];
				sleep 0.15;
				_heli animateSource ["plt_eng1_start", 0];
				["fza_ah64_switch_flip4", 0.1] spawn fza_fnc_playAudio;
			};
			if (_eng1state == "STARTING") then {
				_heli animateSource ["plt_eng1_start", -1];
				sleep 0.15;
				_heli animateSource ["plt_eng1_start", 0];
				["fza_ah64_switch_flip4", 0.1] spawn fza_fnc_playAudio;
			};
		};
	};
	//Power Lever
	case "e1off": {
		[_heli, 0, "OFF", 0.00] spawn fza_fnc_fmThrottle;

		["fza_ah64_throttle_idle", 0.1] spawn fza_fnc_playAudio;
	};
	case "e1idle": {
		[_heli, 0, "IDLE", 0.00] spawn fza_fnc_fmThrottle;

		["fza_ah64_throttle_idle", 0.1] spawn fza_fnc_playAudio;
	};
	case "e1fly": {
		private _eng2State       = fza_simvars_e2State;
		private _eng2PwrLvrState = fza_simvars_e2ThrottlePos;
		//Allow the eng 1 power lever to be advanced individually when the opposite engine
		//is off OR when the opposite engine is on w/ it's power lever at fly
		if (_eng2State == "OFF" || (_eng2State == "ON" && _eng2PwrLvrState == "FLY")) then {
			[_heli, 0, "FLY", 1.00] spawn fza_fnc_fmThrottle;
		};
		//Advance both power levers to fly together when the opposite engine is on and its
		//power lever is at idle
		if (_eng2State == "ON" && _eng2PwrLvrState == "IDLE") then {
			[_heli, 0, "FLY", 1.00] spawn fza_fnc_fmThrottle;
			[_heli, 1, "FLY", 1.00] spawn fza_fnc_fmThrottle;
		};
		
		["fza_ah64_fake_3D", 0.1] spawn fza_fnc_playAudio;
	};
	
	//--------------------ENGINE 2--------------------//	
	//Start Switch
	case "e2start": {
		private _eng2state = fza_simvars_e2State;
		[_heli, 1] call fza_fnc_fmStartSwitch;
		[_heli,_eng2state] spawn {
			params ["_heli","_eng2state"];
			if (_eng2state == "OFF") then {
				_heli animateSource ["plt_eng2_start", 1];
				sleep 0.15;
				_heli animateSource ["plt_eng2_start", 0];
				["fza_ah64_switch_flip4", 0.1] spawn fza_fnc_playAudio;
			};
			if (_eng2state == "STARTING") then {
				_heli animateSource ["plt_eng2_start", -1];
				sleep 0.15;
				_heli animateSource ["plt_eng2_start", 0];
				["fza_ah64_switch_flip4", 0.1] spawn fza_fnc_playAudio;
			};
		};
	};
	//Power Lever
	case "e2off": {
		[_heli, 1, "OFF", 0.00] spawn fza_fnc_fmThrottle;

		["fza_ah64_throttle_idle", 0.1] spawn fza_fnc_playAudio;
	};
	case "e2idle": {
		[_heli, 1, "IDLE", 0.00] spawn fza_fnc_fmThrottle;

		["fza_ah64_throttle_idle", 0.1] spawn fza_fnc_playAudio;
	};
	case "e2fly": {
		private _eng1State       = fza_simvars_e1State;
		private _eng1PwrLvrState = fza_simvars_e1ThrottlePos;
		//Allow the eng 1 power lever to be advanced individually when the opposite engine
		//is off OR when the opposite engine is on w/ it's power lever at fly
		if (_eng1State == "OFF" || (_eng1State == "ON" && _eng1PwrLvrState == "FLY")) then {
			[_heli, 1, "FLY", 1.00] spawn fza_fnc_fmThrottle;
		};
		//Advance both power levers to fly together when the opposite engine is on and its
		//power lever is at idle
		if (_eng1State == "ON" && _eng1PwrLvrState == "IDLE") then {
			[_heli, 0, "FLY", 1.00] spawn fza_fnc_fmThrottle;
			[_heli, 1, "FLY", 1.00] spawn fza_fnc_fmThrottle;
		};
		
		["fza_ah64_fake_3D", 0.1] spawn fza_fnc_playAudio;
	};
};
