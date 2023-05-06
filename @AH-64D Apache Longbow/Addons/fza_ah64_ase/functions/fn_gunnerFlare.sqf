/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_gunnerFlare

Description:
    Action for Gunner to deploy flares
    To be bound in the future with arma 3 mod keybinding update
    
Parameters:
    _heli - the helicopter calling this
    
Returns:
Examples:
    _this Call fza_ase_fnc_gunnerFlare;
Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];
if !(player == gunner _heli) exitwith {};

[vehicle player, "fza_CMFlareLauncher", [-1]] call BIS_fnc_fire;