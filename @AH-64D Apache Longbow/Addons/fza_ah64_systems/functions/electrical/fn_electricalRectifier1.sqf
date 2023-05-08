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

private _gen1On      = _heli getVariable "fza_systems_gen1On";

private _rect1On     = _heli getVariable "fza_systems_rect1On";
private _rect1Damage = _heli getHitPointDamage "hit_elec_rectifier1";

//Set RTRU 1 state
if (_gen1On && _rect1Damage <= SYS_RECT_DMG_THRESH) then {
    _rect1On = true;
} else {
    _rect1On = false;
};
_heli setVariable ["fza_systems_rect1On", _rect1On];