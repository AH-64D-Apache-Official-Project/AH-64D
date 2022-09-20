/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_electricalRectifier2

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

private _gen2State   = _heli getVariable "fza_systems_gen2State";

private _rect2State  = _heli getVariable "fza_systems_rect2State";
private _rect2Damage = _heli getHitPointDamage "hit_elec_rectifier2";

//Set RTRU 2 state
if (_gen2State == "ON" && _rect2Damage <= SYS_RECT_DMG_VAL) then {
    _rect2State = "ON";
} else {
    _rect2State = "OFF";
};
_heli setVariable ["fza_systems_rect2State", _rect2State];