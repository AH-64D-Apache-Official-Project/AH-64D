/* ----------------------------------------------------------------------------
Function: fza_AICrew_fnc_asecontrol


Description:
	Handles ase control for ai crewmembers

Parameters:
	Heli - The helicopter to modify

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_AICrew_fnc_ase
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

if !(fza_ah64_aiAseControl) exitwith {};