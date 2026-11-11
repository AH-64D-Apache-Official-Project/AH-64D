/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_blastFired
Description: Fired handler. Hands the detonation of a blast warhead to the
    server, from the machine that owns the missile.
Parameters: Schema of the "fired" event handler.
Returns: Nothing
Author: Snow(Dryden)
---------------------------------------------------------------------------- */
params ["", "", "", "", "_ammo", "", "_projectile"];

private _isBlast = fza_hellfire_blastAmmo getOrDefaultCall [_ammo, {
    getNumber (configFile >> "CfgAmmo" >> _ammo >> "fza_blastRadius") > 0
}, true];
if (!_isBlast || {!local _projectile}) exitWith {};

_projectile addEventHandler ["Explode", {
    params ["_projectile", "_pos", "_velocity"];
    ["fza_hellfire_blast", [_pos, _velocity, typeOf _projectile, getShotParents _projectile]] call CBA_fnc_serverEvent;
}];
