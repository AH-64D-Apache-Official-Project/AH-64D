/* ----------------------------------------------------------------------------
Function: fza_fnc_fireHandleControl

Description:
    Handles any fire-related cockpit controls.

Parameters:
	_heli - The helicopter to act on
	_system - the name of the system that the touched control belongs to
	_control - the name of the control that has been touched

Returns:
	Nothing

Examples:
	--- Code
    [_heli, "fire", "fe1"] call fireHandleControl
	---

Author:
	Unknown, mattysmith22
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\selections.h"
params ["_heli", "_system", "_control"];

switch(_control) do {
	case "apu": {
		if (isnil "fza_ah64_firetest") then {
			fza_ah64_firetest = 0;
		};
		if (fza_ah64_firetest == 0) exitwith {
			_heli setobjecttexture [SEL_IN_LT_FIRE1, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_FIRE2, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_FIREAPU, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_MSTRCAU, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_MSTRWRN, "\fza_ah64_us\tex\in\pushbut.paa"];
			fza_ah64_firetest = 1;

			if (player == driver _heli) then {
				_heli animate["plt_firesw", 1];
			} else {
				_heli animate["cpg_firesw", 0];
			};



			["fza_ah64_switch_flip4", 0.1] spawn fza_fnc_playAudio;
			[player, "fza_ah64_warntest_3D"] remoteExec["say3d"];
		};
		if (fza_ah64_firetest == 1) exitwith {
			_heli setobjecttexture [SEL_IN_LT_FIRE1, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_FIRE2, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_FIREAPU, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_FIREPDIS, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_FIRERDIS, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_MSTRCAU, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_MSTRWRN, "\fza_ah64_us\tex\in\pushbut.paa"];
			fza_ah64_firetest = 2;

			if (player == driver _heli) then {
				_heli animate["plt_firesw", 0];
			} else {
				_heli animate["cpg_firesw", 1];
			};

			["fza_ah64_switch_flip4", 0.1] spawn fza_fnc_playAudio;
			[player, "fza_ah64_warntest_3D"] remoteExec["say3d"];
		};
		if (fza_ah64_firetest == 2) exitwith {
			_heli setobjecttexture [SEL_IN_LT_FIRE1, ""];
			_heli setobjecttexture [SEL_IN_LT_FIRE2, ""];
			_heli setobjecttexture [SEL_IN_LT_FIREAPU, ""];
			_heli setobjecttexture [SEL_IN_LT_MSTRCAU, ""];
			_heli setobjecttexture [SEL_IN_LT_MSTRWRN, ""];
			if !(_heli getVariable "fza_ah64_firepdisch") then {
				_heli setobjecttexture [SEL_IN_LT_FIREPDIS, ""];
			};
			if !(_heli getVariable "fza_ah64_firerdisch") then {
				_heli setobjecttexture [SEL_IN_LT_FIRERDIS, ""];
			};
			fza_ah64_firetest = 0;

			if (player == driver _heli) then {
				_heli animate["plt_firesw", 0.5];
			} else {
				_heli animate["cpg_firesw", 0.5];
			};

			["fza_ah64_switch_flip4", 0.1] spawn fza_fnc_playAudio;
		};
	};
	case "fe1": {
		if (_heli getVariable "fza_ah64_fire1arm" == 0) exitwith {
			_heli setobjecttexture [SEL_IN_LT_FIRE1RDY, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setVariable ["fza_ah64_fire1arm", 1];
			["fza_ah64_button_click2", 0.1];
		};
		if (_heli getVariable "fza_ah64_fire1arm" == 1) exitwith {
			_heli setobjecttexture [SEL_IN_LT_FIRE1RDY, ""];
			_heli setVariable ["fza_ah64_fire1arm", 0];
			["fza_ah64_button_click2", 0.1];
		};
	};
	case "fe2": {
		if (_heli getVariable "fza_ah64_fire2arm" == 0) exitwith {
			_heli setobjecttexture [SEL_IN_LT_FIRE2RDY, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setVariable ["fza_ah64_fire2arm", 1];
			["fza_ah64_button_click2", 0.1];
		};
		if (_heli getVariable "fza_ah64_fire2arm" == 1) exitwith {
			_heli setobjecttexture [SEL_IN_LT_FIRE2RDY, ""];
			_heli setVariable ["fza_ah64_fire2arm", 0];
			["fza_ah64_button_click2", 0.1];
		};
	};
	case "fapu": {
			if (_heli getVariable "fza_ah64_fireapuarm" == 0) exitwith {
				_heli setobjecttexture [SEL_IN_LT_FIREAPURDY, "\fza_ah64_us\tex\in\pushbut.paa"];
				_heli setVariable ["fza_ah64_fireapuarm", 1];
				["fza_ah64_button_click2", 0.1];
			};
			if (_heli getVariable "fza_ah64_fireapuarm" == 1) exitwith {
				_heli setobjecttexture [SEL_IN_LT_FIREAPURDY, ""];
				_heli setVariable ["fza_ah64_fireapuarm", 0];
				["fza_ah64_button_click2", 0.1];
			};
	};
	case "fbp": {
		if ((_heli getVariable "fza_ah64_fireapuarm" == 1 || _heli getVariable "fza_ah64_fire2arm" == 1 || _heli getVariable "fza_ah64_fire1arm" == 1) && !(_heli getVariable "fza_ah64_firepdisch")) then {
				_heli setobjecttexture [SEL_IN_LT_FIREPDIS, "\fza_ah64_us\tex\in\pushbut.paa"];
				_heli setVariable ["fza_ah64_firepdisch", true, true];
			};
			["fza_ah64_button_click2", 0.1];
		};
		case "fbr": {
			if ((_heli getVariable "fza_ah64_fireapuarm" == 1 || _heli getVariable "fza_ah64_fire2arm" == 1 || _heli getVariable "fza_ah64_fire1arm" == 1) && !(_heli getVariable "fza_ah64_firerdisch")) then {
				_heli setobjecttexture [SEL_IN_LT_FIRERDIS, "\fza_ah64_us\tex\in\pushbut.paa"];
				_heli setVariable ["fza_ah64_firerdisch", true, true];
			};
			["fza_ah64_button_click2", 0.1];
		};
		case "test": {
			if (isnil "fza_ah64_firetest") then {
			fza_ah64_firetest = 0;
		};
		if (fza_ah64_firetest == 0) exitwith {
			_heli setobjecttexture [SEL_IN_LT_FIRE1, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_FIRE2, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_FIREAPU, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_MSTRCAU, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_MSTRWRN, "\fza_ah64_us\tex\in\pushbut.paa"];
			fza_ah64_firetest = 1;

			if (player == driver _heli) then {
				_heli animate["plt_firesw", 1];
			} else {
				_heli animate["cpg_firesw", 0];
			};

			["fza_ah64_switch_flip4", 0.1] spawn fza_fnc_playAudio;
			[player, "fza_ah64_warntest_3D"] remoteExec["say3d"];
		};
		if (fza_ah64_firetest == 1) exitwith {
			_heli setobjecttexture [SEL_IN_LT_FIRE1, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_FIRE2, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_FIREAPU, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_FIREPDIS, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_FIRERDIS, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_MSTRCAU, "\fza_ah64_us\tex\in\pushbut.paa"];
			_heli setobjecttexture [SEL_IN_LT_MSTRWRN, "\fza_ah64_us\tex\in\pushbut.paa"];
			fza_ah64_firetest = 2;

			if (player == driver _heli) then {
				_heli animate["plt_firesw", 0];
			} else {
				_heli animate["cpg_firesw", 1];
			};

			["fza_ah64_switch_flip4", 0.1] spawn fza_fnc_playAudio;
			[player, "fza_ah64_warntest_3D"] remoteExec["say3d"];
		};
		if (fza_ah64_firetest == 2) exitwith {
			_heli setobjecttexture [SEL_IN_LT_FIRE1, ""];
			_heli setobjecttexture [SEL_IN_LT_FIRE2, ""];
			_heli setobjecttexture [SEL_IN_LT_FIREAPU, ""];
			_heli setobjecttexture [SEL_IN_LT_MSTRCAU, ""];
			_heli setobjecttexture [SEL_IN_LT_MSTRWRN, ""];
			if !(_heli getVariable "fza_ah64_firepdisch") then {
				_heli setobjecttexture [SEL_IN_LT_FIREPDIS, ""];
			};
			if !(_heli getVariable "fza_ah64_firerdisch") then {
				_heli setobjecttexture [SEL_IN_LT_FIRERDIS, ""];
			};
			fza_ah64_firetest = 0;

			if (player == driver _heli) then {
				_heli animate["plt_firesw", 0.5];
			} else {
				_heli animate["cpg_firesw", 0.5];
			};

			["fza_ah64_switch_flip4", 0.1] spawn fza_fnc_playAudio;
		};
	};
};