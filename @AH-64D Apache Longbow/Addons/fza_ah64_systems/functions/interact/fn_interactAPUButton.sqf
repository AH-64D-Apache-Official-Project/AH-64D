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

private _apuBtnOn = _heli getVariable "fza_systems_apuBtnOn";

if (_apuBtnOn) then {
	_apuBtnOn = false;
} else {
	_apuBtnOn = true;
};
_heli setVariable ["fza_systems_apuBtnOn", _apuBtnOn, true];

/*
switch (_apuBtnOn) do {
	case "OFF": {
		_apuBtnOn = "ON";
		_heli setVariable ["fza_systems_apuBtnOn", _apuBtnOn, true];

		false;
	};
	case "ON": {
		_apuBtnOn = "OFF";
		_heli setVariable ["fza_systems_apuBtnOn", _apuBtnOn, true];

		true;
	};
	default {
		false;
	}
};*/