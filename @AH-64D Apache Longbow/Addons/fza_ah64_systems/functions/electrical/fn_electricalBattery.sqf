/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_electricalBattery

Description:
	Updates all of the modules core functions.
	
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

private _battSwitchState = _heli getVariable "fza_systems_battSwitchState";
private _battPower       = _heli getVariable "fza_systems_battPower_pct";
private _ACBusState      = _heli getVariable "fza_systems_ACBusState";
private _battTimer       = _heli getVariable "fza_systems_battTimer";
private _battDamage      = _heli getHitPointDamage "hit_elec_battery";
private _battBusState    = _heli getVariable "fza_systems_battBusState";

if (_battSwitchState == "ON") then {
	if (_battDamage <= SYS_BATT_DMG_VAL && _battPower >= 0.25) then {
    	_battBusState = "ON";
	} else {
		_battBusState = "OFF";
	};
} else {
    _battBusState = "OFF";
};
//Set the state of the battery bus
_heli setVariable ["fza_systems_battBusState", _battBusState];
//Drain the battery
if (_battBusState == "ON" && _ACBusState == "OFF") then {
	_battPower = [_battPower, 0.0, (1.0 / _battTimer) * _deltaTime] call BIS_fnc_lerp;
};
//Recharge the battery
if (_battBusState == "ON" && _ACBusState == "ON") then {
	_battPower = [_battPower, 1.0, _deltaTime] call BIS_fnc_lerp;
};
_heli setVariable ["fza_systems_battPower_pct", _battPower];

//Components belonging to the battery bus include:
//--FS/BS UFD
//--FS/BS Fire test panel
//--FS/BS Landing/Searchlight
//--VHF radio
//--UHF radio
//--FM1 radio
//--FM2 radio
//--Standby instruments