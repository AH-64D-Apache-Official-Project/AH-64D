/* ----------------------------------------------------------------------------
Function: fza_AICrew_fnc_init


Description:
	To set up the aircraft for full ai crew

Parameters:
	Heli - The helicopter to modify

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_AICrew_fnc_init
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

//Gets AI rocketpods to work & aim accurate
_heli animateSource["pylon1", 0]; 
_heli animateSource["pylon2", 0]; 
_heli animateSource["pylon3", 0]; 
_heli animateSource["pylon4", 0];