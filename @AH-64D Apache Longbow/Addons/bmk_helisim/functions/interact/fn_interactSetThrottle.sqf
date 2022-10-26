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
params ["_heli", "_engNum", "_throttle"];

[_heli, "bmk_helisim_engineThrottle", _engNum, _throttle] call fza_sfmplus_fnc_setArrayVariable;