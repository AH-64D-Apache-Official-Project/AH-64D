/* ----------------------------------------------------------------------------
Function: fza_aiCrew_fnc_fireControl


Description:
	handles the ai controls sequence for putting out fires
	fire suppresion does not work on full ai crew so it is disabled for full ai crew

Parameters:
	Heli: Object - The helicopter to modify

Returns:
	Nothing

Examples:
	--- Code
    [_this] spawn fza_aiCrew_fnc_fireControl
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];
#include "\fza_ah64_controls\headers\script_common.hpp"

if !fza_ah64_aiFirecontrol exitwith {};
if (_heli getVariable "fza_ah64_aiFireHandling") exitWith {}; //Prevent this from being run multiple times simultaneously
_heli setVariable ["fza_ah64_aiFireHandling", true];
_driver = driver vehicle _heli;
_gunner = gunner vehicle _heli;

if !((alive _driver && !isPlayer _driver) || (alive _gunner && !isPlayer _gunner)) exitWith {};

sleep fza_ah64_aiFireResponse;
if !(_heli getVariable "fza_ah64_e1_fire" || _heli getVariable "fza_ah64_e2_fire" || _heli getVariable "fza_ah64_apu_fire") exitWith {};
if (_heli getVariable "fza_ah64_e1_fire") then {
	[_heli, "eng1", true] call fza_fnc_fireHandlepanel;
};
sleep 0.4;
if (_heli getVariable "fza_ah64_e2_fire") then {
	[_heli, "eng2", true] call fza_fnc_fireHandlepanel;
};
sleep 0.4;
if (_heli getVariable "fza_ah64_apu_fire") then {
	[_heli, "apu", true] call fza_fnc_fireHandlepanel;
};
sleep 0.4;
if (_heli getVariable "fza_ah64_e1_fire" || _heli getVariable "fza_ah64_e2_fire" || _heli getVariable "fza_ah64_apu_fire") then {
	if !(_heli getVariable "fza_ah64_firepdisch") then {
		_heli setobjecttexture ["in_lt_firepdis", "\fza_ah64_us\tex\in\pushbut.paa"];
		_heli setVariable ["fza_ah64_firepdisch", true, true];
		_dmg = _heli getHit "leng";
		_heli setHit ["leng", _dmg + 0.01];
	} else {
		sleep 1;
		if (_heli getVariable "fza_ah64_e1_fire" || _heli getVariable "fza_ah64_e2_fire" || _heli getVariable "fza_ah64_apu_fire") then {
			if !(_heli getVariable "fza_ah64_firerdisch") then {
				_heli setobjecttexture ["in_lt_firerdis", "\fza_ah64_us\tex\in\pushbut.paa"];
				_heli setVariable ["fza_ah64_firerdisch", true, true];
				_dmg = _heli getHit "Reng";
				_heli setHit ["Reng", _dmg + 0.01];
			};
		};
	};
};
_heli setVariable ["fza_ah64_aiFireHandling", false];
sleep 3;
[_heli, "eng1", false] call fza_fnc_fireHandlepanel;
sleep 0.4;
[_heli, "eng2", false] call fza_fnc_fireHandlepanel;
sleep 0.4;
[_heli, "apu", false] call fza_fnc_fireHandlepanel;
