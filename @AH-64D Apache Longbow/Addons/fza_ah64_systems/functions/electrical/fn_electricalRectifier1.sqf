/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_electricalRectifier1

Description:
	Updates all of the modules core functions.
	
Parameters:
	_heli - The helicopter to get information from [Unit].

Returns:
	...

Examples:
	...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"];
#include "\fza_ah64_systems\headers\systems.hpp"

private _gen1State   = _heli getVariable "fza_systems_gen1State";

private _rect1State  = _heli getVariable "fza_systems_rect1State";
private _rect1Damage = _heli getHitPointDamage "hit_elec_rectifier1";

//Set RTRU 1 state
if (_gen1State == "ON" && _rect1Damage <= SYS_RECT_DMG_VAL) then {
    _rect1State = "ON";
} else {
    _rect1State = "OFF";
};
_heli setVariable ["fza_systems_rect1State", _rect1State];