/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_suspensionVariables

Description:
    Declares the variables used by the suspension system.
    
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
/*
_heli setVariable ["fza_sfmplus_wheelInitialized", [false,false,false]];
_heli setVariable ["fza_sfmplus_restCompression",  [0.0, 0.0, 0.0]];
_heli setVariable ["fza_sfmplus_prevCompression",  [0.0, 0.0, 0.0]];
_heli setVariable ["fza_sfmplus_contactFrames",    [0, 0, 0]];
_heli setVariable ["fza_sfmplus_hasLanded",        [false, false, false]];
*/

_heli setVariable ["fza_sfmplus_wheelPrevSuspDistance",     [0.0, 0.0, 0.0]];
_heli setVariable ["fza_sfmplus_springConstants",           [0.0, 0.0, 0.0]];
_heli setVariable ["fza_sfmplus_damperConstants",           [0.0, 0.0, 0.0]];

// Suspension frame counter for settling period
_heli setVariable ["fza_sfmplus_suspensionFrameCount", 0];

// Per-wheel settled state: once velocity stays below 0.05 m/s for 1 s, freeze the spring
// constant (eliminates getCenterOfMass noise) while keeping live compression (preserves
// roll/pitch restoring).  Disturbance detection is velocity-based (> 0.5 m/s) so only
// real impacts unsettle the wheel, not slow roll drift.
_heli setVariable ["fza_sfmplus_wheelSettled",    [false, false, false]];
_heli setVariable ["fza_sfmplus_wheelSettleTime", [0.0,   0.0,   0.0]];
_heli setVariable ["fza_sfmplus_wheelSettledK",   [0.0,   0.0,   0.0]];
_heli setVariable ["fza_sfmplus_wheelSettledC",   [0.0,   0.0,   0.0]];

// Time-acceleration freeze state: captures position/orientation on entry and overrides
// PhysX every frame so the aircraft is immune to gravity and terrain collision bounce.
_heli setVariable ["fza_sfmplus_simFrozen",  false];
_heli setVariable ["fza_sfmplus_frozenPos",  [0.0, 0.0, 0.0]];
_heli setVariable ["fza_sfmplus_frozenDir",  [0.0, 1.0, 0.0]];
_heli setVariable ["fza_sfmplus_frozenUp",   [0.0, 0.0, 1.0]];

// Ground freeze: same mechanism as time-accel freeze but triggered by all wheels settling.
// Holds the aircraft perfectly still until collective exceeds 0.20.
_heli setVariable ["fza_sfmplus_groundFrozen",    false];
_heli setVariable ["fza_sfmplus_groundFrozenPos", [0.0, 0.0, 0.0]];
_heli setVariable ["fza_sfmplus_groundFrozenDir", [0.0, 1.0, 0.0]];
_heli setVariable ["fza_sfmplus_groundFrozenUp",  [0.0, 0.0, 1.0]];

// Spawn correction: Arma 3 places the helicopter via the fuselage collision hull, which
// leaves wheel contact points underground and sometimes with residual bank/pitch.
// PhysX then generates asymmetric body-terrain collision torques every frame, causing
// persistent roll drift that the angular damping can't cancel.
// Fix: level the aircraft, lift it to wheel-on-terrain height, and zero initial velocity.
private _spawnWheelPos = [[ 1.09, 3.39, -2.98], [-1.09, 3.39, -2.98]];  // front wheel centres
private _spawnRadius   = 0.31;
private _spawnStrutH   = 0.62;

// Level the aircraft — keep heading, zero bank and pitch.
private _spawnDir  = vectorDir _heli;
private _spawnDirH = [_spawnDir select 0, _spawnDir select 1, 0.0];
if (vectorMagnitude _spawnDirH > 0.01) then {
    _heli setVectorDirAndUp [vectorNormalized _spawnDirH, [0.0, 0.0, 1.0]];
};

// Lift so average front-wheel compression reaches zero (contact points on terrain).
private _liftSum = 0.0;  private _liftN = 0;
{
    private _topASL = _heli modelToWorldWorld (_x vectorAdd [0.0, 0.0, _spawnRadius]);
    private _hit    = lineIntersectsSurfaces [_topASL, _topASL vectorAdd [0.0, 0.0, -(_spawnStrutH + 0.3)],
                                              _heli, objNull, true, 1, "GEOM"];
    if (count _hit > 0) then {
        private _d = _spawnStrutH - ((_topASL select 2) - ((_hit select 0 select 0) select 2));
        if (_d > 0.0) then { _liftSum = _liftSum + _d;  _liftN = _liftN + 1; };
    };
} forEach _spawnWheelPos;

if (_liftN > 0) then {
    private _p = getPosASL _heli;
    _heli setPosASL [_p select 0, _p select 1, (_p select 2) + (_liftSum / _liftN)];
};

_heli setVelocity        [0.0, 0.0, 0.0];
_heli setAngularVelocity [0.0, 0.0, 0.0];