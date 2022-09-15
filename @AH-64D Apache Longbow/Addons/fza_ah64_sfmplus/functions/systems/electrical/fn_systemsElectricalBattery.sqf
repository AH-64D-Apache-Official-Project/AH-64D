/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_systemsElectricalBattery

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
params ["_heli"];

private _battSwitchState = _heli getVariable "fza_sfmplus_battSwitchState";
private _battBusState    = _heli getVariable "fza_sfmplus_battBusState";

if (_battSwitchState == "ON") then {
    _battBusState = "ON";
} else {
    _battBusState = "OFF";
};
//Set the state of the battery bus
_heli setVariable ["fza_sfmplus_battBusState", _battBusState];
//Components belonging to the battery bus include:
//--FS/BS UFD
//--FS/BS Fire test panel
//--FS/BS Landing/Searchlight
//--VHF radio
//--UHF radio
//--FM1 radio
//--FM2 radio
//--Standby instruments