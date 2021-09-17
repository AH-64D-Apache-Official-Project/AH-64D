/* ----------------------------------------------------------------------------
Function: fza_AICrew_fnc_floodlight

Description:
	handles the floodlighting control for ai

Parameters:
	Heli: Object - The helicopter to modify

Returns:
	Nothing

Examples:
    [_this] call fza_AICrew_fnc_floodlight;

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];
if (isplayer driver _heli && isplayer gunner _heli) exitWith {};

_driver = driver vehicle _heli;
_gunner = gunner vehicle _heli;

if ((alive _driver && !isPlayer _driver) || (alive _gunner && !isPlayer _gunner)) then {
	if (fza_ah64_aiFloodlight == true) then {
		if ((daytime > 20.0 || daytime < 4.20) && (!(isLightOn [_heli,[0]]) && _heli animationphase "plt_batt" > 0.5)) then {
			[_heli, _system, "floodlight"] call fza_fnc_lightHandleControl;
		};
		if ((daytime < 20.0 && daytime > 4.20) && ((isLightOn [_heli,[0]]) && _heli animationphase "plt_batt" > 0.5)) then {
			[_heli, _system, "floodlight"] call fza_fnc_lightHandleControl;
		};
	};
};