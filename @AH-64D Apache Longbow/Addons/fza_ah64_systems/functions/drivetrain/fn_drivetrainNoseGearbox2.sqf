/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_drivetrainNoseGearbox2

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

private _NGB2Damage    = _heli getHitPointDamage "hit_drives_noseGearbox2";
private _eng2Overspeed = false;

if (_NGB2Damage >= SYS_NGB_DMG_THRESH) then {
    _eng2Overspeed = true;
    [_heli, "fza_ah64_engineOverspeed", 1, _eng2Overspeed, true] call fza_fnc_setArrayVariable;
};