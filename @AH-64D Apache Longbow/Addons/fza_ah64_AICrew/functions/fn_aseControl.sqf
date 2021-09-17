/* ----------------------------------------------------------------------------
Function: fza_AICrew_fnc_asecontrol


Description:
	Handles ase control for ai crewmembers

Parameters:
	Heli: Object - The helicopter to modify

Returns:
	Nothing

Examples:
	--- Code
    [_this] call fza_AICrew_fnc_asecontrol
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];
if !(fza_ah64_aiAseControl) exitwith {};

_driver = driver vehicle _heli;
_gunner = gunner vehicle _heli;

if ((alive _driver && !isPlayer _driver) || (alive _gunner && !isPlayer _gunner)) then {
	_heli setVariable ["fza_ah64_irjstate", 1];
	_heli setVariable ["fza_ah64_rfjstate", 1];
};