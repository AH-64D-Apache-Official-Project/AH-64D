/* ----------------------------------------------------------------------------
Function: fza_fnc_eventFired

Description:
    Submunition creation event handler

    projectile: Object
    subMunitionProjectile: Object
    pos: Array format PositionASL
    velocity: Array format Vector3D

Parameters:

Returns:
    Nothing

Examples:

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_projectile", "_submunitionProjectile", "_pos", "_velocity"];

if (typeOf _submunitionProjectile == "fza_flec_cluster") then {
    _counter = floor random 100;
    if (_counter > 3) exitWith {};
    drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 9, 1], "", "Billboard", 0.5, 5, [0,0,0], [0,0,0], 0, 0.7, 0.5, 1, [8,16,24,32,36], [[0.4,0,0,0.8],[0.4,0,0,0.7],[0.4,0,0,0.6],[0.4,0,0,0.5],[0,0,0,0]], [0], 0.1, 0.2, "", "", _submunitionProjectile];
};