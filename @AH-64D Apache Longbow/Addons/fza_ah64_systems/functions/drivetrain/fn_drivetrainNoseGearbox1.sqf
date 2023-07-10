/* ----------------------------------------------------------------------------
Function: fza_systems_fnc_drivetrainNoseGearbox1

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

private _NGB1Damage    = _heli getHitPointDamage "hit_drives_noseGearbox1";
private _eng1Overspeed = false;

if (_NGB1Damage >= SYS_NGB_DMG_THRESH) then {
    _eng1Overspeed = true;
    [_heli, "fza_ah64_engineOverspeed", 0, _eng1Overspeed, true] call fza_fnc_setArrayVariable;
};