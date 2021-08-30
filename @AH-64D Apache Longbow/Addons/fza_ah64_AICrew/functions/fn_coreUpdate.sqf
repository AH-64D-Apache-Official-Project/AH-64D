/* ----------------------------------------------------------------------------
Function: fza_AICrew_fnc_coreUpdate

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
if !(alive _heli && (_heli) isKindOf "fza_ah64base") exitwith {};

[_heli] spawn fza_AICrew_fnc_init;
[_heli] spawn fza_AICrew_fnc_fireControl;
[_heli] spawn fza_AICrew_fnc_ase;

if ((daytime > 20.0 || daytime < 4.20) && fza_ah64_aiFloodlight == true && (!(isLightOn [_heli,[0]]) && _heli animationphase "plt_batt" > 0.5)) then {
	[_heli, _system, "floodlight"] call fza_fnc_lightHandleControl;
};