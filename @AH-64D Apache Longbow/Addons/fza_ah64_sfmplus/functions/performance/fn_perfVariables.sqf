/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_perfVariables

Description:
	Sets the initial mass of the helicopter.

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

_heli setVariable ["fza_sfmplus_maxTQ_DE",     0.0];
_heli setVariable ["fza_sfmplus_maxTQ_SE",     0.0];
_heli setVariable ["fza_sfmplus_maxGWT_IGE",   0.0];
_heli setVariable ["fza_sfmplus_maxGWT_OGE",   0.0];
_heli setVariable ["fza_sfmplus_goNoGoTQ_IGE", 0.0];
_heli setVariable ["fza_sfmplus_goNoGoTQ_OGE", 0.0];
_heli setVariable ["fza_sfmplus_hvrTQ_IGE",    0.0];
_heli setVariable ["fza_sfmplus_hvrTQ_OGE",    0.0];