/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_munitionInit

Description:
    Lists missiles and rockets as they are created on this machine, fired or spawned, in fza_ase_munitions (by
    hashValue), for the MWS and LWR (fza_ase_fnc_aseManager). Only while an AH-64D's ASE has run here in the last
    ASE_MUNITION_TRACK_HOLD seconds; every other projectile costs one time check.

Parameters:
    Nothing

Returns:
    Nothing

Examples:
    call fza_ase_fnc_munitionInit

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
if (!isNil "fza_ase_munitionEh") exitWith {};
fza_ase_munitions          = createHashMap;
fza_ase_munitionTypes      = createHashMap;
fza_ase_munitionTrackUntil = -1;
fza_ase_munitionEh = addMissionEventHandler ["ProjectileCreated", {
    if (CBA_missionTime >= fza_ase_munitionTrackUntil) exitWith {};
    params ["_projectile"];
    if (fza_ase_munitionTypes getOrDefaultCall [typeOf _projectile, {_projectile isKindOf "MissileBase" || {_projectile isKindOf "RocketBase"}}, true]) then {
        fza_ase_munitions set [hashValue _projectile, _projectile];
    };
}];
