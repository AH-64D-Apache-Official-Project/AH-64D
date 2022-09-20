/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_drivetrainTailRotorGearboxes

Description:
    ...

Parameters:
	_heli      - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
	BradMick
---------------------------------------------------------------------------- */
params ["_heli"];
#include "\fza_ah64_systems\headers\systems.hpp"

private _IGBDamage  = _heli getHitPointDamage "hit_drives_intermediategearbox";
private _TGBDamage  = _heli getHitPointDamage "hit_drives_tailrotorgearbox";

if (_IGBDamage >= SYS_IGB_DMG_VAL || _TGBDamage >= SYS_TGB_DMG_VAL) then {
    _heli setHitPointDamage ["hitvrotor", 1.0];
};