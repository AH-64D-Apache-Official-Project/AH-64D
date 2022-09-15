/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_interactBattSwitch

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

private _battSwitchState = _heli getVariable "fza_sfmplus_battSwitchState";

switch (_battSwitchState
) do {
	case "OFF": {
		_battSwitchState = "ON";
		_heli setVariable ["fza_sfmplus_battSwitchState", _battSwitchState, true];

		false;
	};
	case "ON": {
		_battSwitchState = "OFF";
		_heli setVariable ["fza_sfmplus_battSwitchState", _battSwitchState, true];

		true;
	};
	default {
		true;
	}
};
