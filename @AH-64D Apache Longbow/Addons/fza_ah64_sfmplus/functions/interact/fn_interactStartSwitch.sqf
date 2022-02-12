/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_interactStartSwitch

Description:
	Sets start switch state for the engine sim.

Parameters:
	_heli   - The helicopter to get information from [Unit].
	_engNum - The desired engine.

Returns:
	Whether to register a click (boolean).

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_engNum"];

if (_heli getVariable "fza_ah64_rtrbrake") exitWith {};

private _engState    = _heli getVariable "fza_sfmplus_engState" select _engNum;

switch (_engState) do {
	case "STARTING": {
		_engState = "OFF";
		[_heli, "fza_sfmplus_engState", _engNum, _engState, true] call fza_sfmplus_fnc_setArrayVariable;

		false;
	};
	case "OFF": {
		_engState = "STARTING";
		[_heli, "fza_sfmplus_engState", _engNum, _engState, true] call fza_sfmplus_fnc_setArrayVariable;

		true;
	};
	default {
		true;
	}
};
