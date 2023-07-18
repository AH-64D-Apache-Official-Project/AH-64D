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
params["_heli", "_system", "_damage"];

if (_system == "hit_apu" && _damage >= 0.4) then {
    [_heli, "fza_ah64_apu_fire"] spawn fza_fire_fnc_damageEngineFire;
};

if (_system == "hitengine1" && _damage >= 0.4) then {
    [_heli, "fza_ah64_e1_fire"] spawn fza_fire_fnc_damageEngineFire;
};

if (_system == "hitengine2" && _damage >= 0.4) then {
    [_heli, "fza_ah64_e2_fire"] spawn fza_fire_fnc_damageEngineFire;
};