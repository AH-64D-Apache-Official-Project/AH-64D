/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_perfVariables

Description:
	Defines the initial performance page variables and initializes them.

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

_heli setVariable ["fza_sfmplus_reqEngTorque",  0.0];