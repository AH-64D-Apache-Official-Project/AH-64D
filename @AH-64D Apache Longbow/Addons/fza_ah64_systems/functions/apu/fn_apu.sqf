/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_systemsAPU

Description:
	Defines key values for the simulation.

Parameters:
	_heli - The helicopter to get information from [Unit].

Returns:
	...

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_deltaTime"];
#include "\fza_ah64_systems\headers\systems.hpp"

private _apuBtnState   = _heli getVariable "fza_systems_apuBtnState";
private _battBusState  = _heli getVariable "fza_systems_battBusState";
private _apuState      = _heli getVariable "fza_systems_apuState";
private _apuDamage     = _heli getHitPointDamage "hit_apu";
private _apuStartDelay = _heli getVariable "fza_systems_apuStartDelay";
private _apuRPM_pct    = _heli getVariable "fza_systems_apuRPM_pct";

if (_apuBtnState == "ON" && _battBusState == "ON") then {
    _apuRPM_pct = [_apuRPM_pct, 1.0, (1.0 / _apuStartDelay) * _deltaTime] call BIS_fnc_lerp;
} else {
    _apuRPM_pct = [_apuRPM_pct, 0.0, _deltaTime] call BIS_fnc_lerp;
};
_heli setVariable ["fza_systems_apuRPM_pct", _apuRPM_pct];

//Set the APU state
if (_apuRPM_pct <= SYS_MIN_RPM) then {
    _apuState = "OFF";
};
if (_apuRPM_pct > SYS_MIN_RPM) then {
	if (_apuDamage <= SYS_APU_DMG_VAL) then {
    	_apuState = "ON";
	} else {
		_apuState = "OFF";
	};
};
_heli setVariable ["fza_systems_apuState", _apuState];