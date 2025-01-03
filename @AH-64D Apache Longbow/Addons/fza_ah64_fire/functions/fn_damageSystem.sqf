/* ----------------------------------------------------------------------------
Function: fza_fire_fnc_damageSystem

Description:
    Handles general damage to the aircraft. Determines whether a failure should be simulated and if so, sets it up.

Parameters:
    _heli - The helicopter to modify
    _system - The *HitPoint* that was damaged
    _damage - The damage amount of the *HitPoint* (0-1)

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_fire_fnc_damageSystem
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_systems\headers\systems.hpp"
#include "\fza_ah64_sfmplus\headers\core.hpp"
params["_heli", "_system", "_damage"];

private _apuOn     = _heli getVariable "fza_systems_apuOn";
private _engState  = _heli getVariable "fza_sfmplus_engState";
private _eng1State = _engState select 0;
private _eng2State = _engState select 1;

if (_system == "hit_apu" && _damage >= SYS_APU_DMG_THRESH && _apuOn) then {
    [_heli, "apu"] spawn fza_fire_fnc_damageEngineFire;
};

if (_system == "hitengine1" && _damage >= SYS_ENG_DMG_THRESH && _eng1State != ENG_OFF) then {
    [_heli, "left"] spawn fza_fire_fnc_damageEngineFire;
};

if (_system == "hitengine2" && _damage >= SYS_ENG_DMG_THRESH && _eng2State != ENG_OFF) then {
    [_heli, "right"] spawn fza_fire_fnc_damageEngineFire;
};