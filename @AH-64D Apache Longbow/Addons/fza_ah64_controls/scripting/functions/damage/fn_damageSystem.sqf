/* ----------------------------------------------------------------------------
Function: fza_fnc_damageSystem

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
    [_heli] call fza_fnc_damageSystem
    ---

Author:
    Unknown
---------------------------------------------------------------------------- */
params["_heli", "_system", "_damage"];

if (_system == "hit_msnEquip_gun_turret" && _damage >= 0.8) then {
    _heli setAmmo ["fza_m230", 0];
};

if (_system == "hit_apu" && _damage >= 0.4) then {
    [_heli, "apu"] spawn fza_fnc_damageEngineFire;
};

if (_system == "hitengine1" && _damage >= 0.4) then {
    [_heli, "left"] spawn fza_fnc_damageEngineFire;
};

if (_system == "hitengine2" && _damage >= 0.4) then {
    [_heli, "right"] spawn fza_fnc_damageEngineFire;
};