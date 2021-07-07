/* ----------------------------------------------------------------------------
Function: fza_fnc_aseGunnerFlare

Description:
    Action for Gunner to deploy flares
    To be bound in the future with arma 3 mod keybinding update

Parameters:
    
Returns:

Examples:
    _this Call fza_fnc_aseGunnerFlare;

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];
if !(player == gunner _heli) exitwith {};

[vehicle player, "fza_CMFlareLauncher", [-1]] call BIS_fnc_fire;
