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

private _gen2On      = _heli getVariable "fza_systems_gen2On";

private _rect2On     = _heli getVariable "fza_systems_rect2On";
private _rect2Damage = _heli getHitPointDamage "hit_elec_rectifier2";

//Set RTRU 2 state
if (_gen2On && _rect2Damage <= SYS_RECT_DMG_THRESH) then {
    _rect2On = true;
} else {
    _rect2On = false;
};
_heli setVariable ["fza_systems_rect2On", _rect2On];