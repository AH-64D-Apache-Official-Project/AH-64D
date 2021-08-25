/* ----------------------------------------------------------------------------
Function: fza_aifunction_fnc_setupinit


Description:
	To set up the aircraft for full ai crew

Parameters:
	Heli - The helicopter to modify

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_aifunction_fnc_fireControl
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

/*
if (isplayer driver _heli == false) then {