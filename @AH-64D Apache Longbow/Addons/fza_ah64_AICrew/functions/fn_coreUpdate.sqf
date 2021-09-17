/* ----------------------------------------------------------------------------
Function: fza_AICrew_fnc_coreUpdate

Description:
	handles the spawning of the ai functions

Parameters:
	Heli: Object - The helicopter to modify

Returns:
	Nothing

Examples:
	[_heli] call fza_AICrew_fnc_coreUpdate;

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];
if (isplayer driver _heli && isplayer gunner _heli) exitWith {};
_driver = driver vehicle _heli;
_gunner = gunner vehicle _heli;

if ((alive _driver && !isPlayer _driver) || (alive _gunner && !isPlayer _gunner)) then {
	[_heli] call fza_AICrew_fnc_floodlight; // only functions with a player and ai crew
	[_heli] call fza_AICrew_fnc_asecontrol; // only functions with a player and ai crew
	//[_heli] call fza_AICrew_fnc_fireControl; // called in damage systems when engine fire starts for non player crew compat
};