/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_interactAPUButton

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

private _apuBtnState = _heli getVariable "fza_systems_apuBtnState";

switch (_apuBtnState) do {
	case "OFF": {
		_apuBtnState = "ON";
		_heli setVariable ["fza_systems_apuBtnState", _apuBtnState, true];

		false;
	};
	case "ON": {
		_apuBtnState = "OFF";
		_heli setVariable ["fza_systems_apuBtnState", _apuBtnState, true];

		true;
	};
	default {
		true;
	}
};
