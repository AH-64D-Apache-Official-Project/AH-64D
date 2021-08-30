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

if (isplayer driver _heli && isplayer gunner _heli) exitWith {};

_heli animateSource["pylon1", 5]; 
_heli animateSource["pylon2", 5]; 
_heli animateSource["pylon3", 5]; 
_heli animateSource["pylon4", 5];