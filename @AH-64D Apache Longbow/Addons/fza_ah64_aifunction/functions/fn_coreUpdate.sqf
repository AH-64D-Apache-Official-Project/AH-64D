/* ----------------------------------------------------------------------------
Function: fza_aifunction_fnc_coreUpdate

Description:
	handles the spawning of the ai functions

Parameters:
	Heli - The helicopter to modify

Returns:
	Nothing

Examples:

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if (isplayer driver _heli && isplayer gunner _heli) exitWith {};

[_heli] spawn fza_aifunction_fnc_init;
[_heli] spawn fza_aifunction_fnc_fireControl;
[_heli] spawn fza_aifunction_fnc_ase;