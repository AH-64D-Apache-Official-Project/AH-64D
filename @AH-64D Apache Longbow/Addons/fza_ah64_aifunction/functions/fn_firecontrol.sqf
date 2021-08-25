/* ----------------------------------------------------------------------------
Function: fza_aifunction_fnc_fireControl


Description:
	handles the ai controls sequence for putting out fires

Parameters:
	Heli - The helicopter to modify

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_aifunction_fnc_fireControl
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];
#include "\fza_ah64_controls\headers\script_common.hpp"
#include "\fza_ah64_controls\headers\selections.h"

//if (player = driver _heli && player = gunner _heli || fza_ah64_aiFirecontrol == false) exitWith {};

if (_heli getVariable "fza_ah64_e1_fire" || _heli getVariable "fza_ah64_e2_fire" || _heli getVariable "fza_ah64_apu_fire") then {
	Sleep 10;
	if (_heli getVariable "fza_ah64_e1_fire") then {
		_heli setobjecttexture [SEL_IN_LT_FIRE1RDY, "\fza_ah64_us\tex\in\pushbut.paa"];
		_heli setVariable ["fza_ah64_fire1arm", 1];
	};
	sleep 0.4;
	if (_heli getVariable "fza_ah64_e2_fire") then {
		_heli setobjecttexture [SEL_IN_LT_FIRE2RDY, "\fza_ah64_us\tex\in\pushbut.paa"];
		_heli setVariable ["fza_ah64_fire2arm", 1];
	};
	sleep 0.4;
	if (_heli getVariable "fza_ah64_apu_fire") then {
		_heli setobjecttexture [SEL_IN_LT_FIREAPURDY, "\fza_ah64_us\tex\in\pushbut.paa"];
		_heli setVariable ["fza_ah64_fireapuarm", 1];
	};
	sleep 0.4;
	if (_heli getVariable "fza_ah64_e1_fire" || _heli getVariable "fza_ah64_e2_fire" || _heli getVariable "fza_ah64_apu_fire") then {
		if (_heli ammo "fza_Fx1" == 1) then {
		_heli setobjecttexture [SEL_IN_LT_FIREPDIS, "\fza_ah64_us\tex\in\pushbut.paa"];
		_heli setVariable ["fza_ah64_firepdisch", true, true];
		_heli removeMagazinesTurret ["fza_Fb1", [0]];
		_heli addMagazineTurret ["fza_Fb1", [0], 0];
		} else {
			sleep 1;
			if (_heli getVariable "fza_ah64_e1_fire" || _heli getVariable "fza_ah64_e2_fire" || _heli getVariable "fza_ah64_apu_fire") then {
				_heli setobjecttexture [SEL_IN_LT_FIRERDIS, "\fza_ah64_us\tex\in\pushbut.paa"];
				_heli setVariable ["fza_ah64_firerdisch", true, true];
				_heli removeMagazinesTurret ["fza_Fb2", [0]];
				_heli addMagazineTurret ["fza_Fb2", [0], 0];
			};
		};
	};
	sleep 3;
	_heli setobjecttexture [SEL_IN_LT_FIRE1RDY, ""];
	_heli setVariable ["fza_ah64_fire1arm", 0];
	sleep 0.4;
	_heli setobjecttexture [SEL_IN_LT_FIRE2RDY, ""];
	_heli setVariable ["fza_ah64_fire2arm", 0];
	sleep 0.4;
	_heli setobjecttexture [SEL_IN_LT_FIREAPURDY, ""];
	_heli setVariable ["fza_ah64_fireapuarm", 0];
};