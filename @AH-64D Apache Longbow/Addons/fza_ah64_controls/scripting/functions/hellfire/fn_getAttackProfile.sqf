/* ----------------------------------------------------------------------------
Function: fza_fnc_getAttackProfile

Description:
	Calls the Ace Radar hellfire Guidance Perframe event handler with Desired input

Parameters:
    _heli - the helicopter

Returns:
	Nothing

Examples:
    [_heli] call fza_fnc_getAttackProfile

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

"hellfire";
/*
"hellfire"
"hellfire_hi"
"hellfire_lo"
we may need to create our own Attack profiles, as aces deviate from the real trajectories