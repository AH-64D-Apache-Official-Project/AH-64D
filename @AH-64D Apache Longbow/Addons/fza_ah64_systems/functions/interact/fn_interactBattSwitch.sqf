/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_interactBattSwitch

Description:
	Sets button state for the APU sim.

Parameters:
	_heli   - The helicopter to get information from [Unit].

Returns:
	Whether to register a click (boolean).

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _battSwitchOn = _heli getVariable "fza_systems_battSwitchOn";

if (_battSwitchOn) then {
	_battSwitchOn = false;
} else {
	_battSwitchOn = true;
};
_heli setVariable ["fza_systems_battSwitchOn", _battSwitchOn, true];
/*
switch (_battSwitchOn) do {
	case "OFF": {
		_battSwitchOn = "ON";
		_heli setVariable ["fza_systems_battSwitchOn", _battSwitchOn, true];

		false;
	};
	case "ON": {
		_battSwitchOn = "OFF";
		_heli setVariable ["fza_systems_battSwitchOn", _battSwitchOn, true];

		true;
	};
	default {
		true;
	}
};*/
