/* ----------------------------------------------------------------------------
Function: fza_aifunction_fnc_coreUpdate

Description:
	handles the spawning of the ai functions

Parameters:
	Heli - The helicopter to modify

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_aifunction_fnc_coreUpdate
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

[heli] spawn fza_aifunction_fnc_fireControl;