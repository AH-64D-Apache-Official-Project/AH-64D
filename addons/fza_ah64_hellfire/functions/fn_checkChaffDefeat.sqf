/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_checkChaffDefeat
Description: Returns true when chaff defeats a radar lock attempt based on
    nearby radar-blocking countermeasures in seeker cone and LOS.
Parameters:
    _seeker       - Seeker object (missile in flight, helicopter during handoff)
    _target       - Candidate target object
    _seekerAngle  - Seeker cone half-angle in degrees
    _chaffCoef    - Mission-level chaff effectiveness coefficient
Returns: Boolean
Author: Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_seeker", "_target", "_seekerAngle", "_chaffCoef"];

if (isNull _target) exitWith { false };

private _chaffNearby = _target nearObjects RF_CM_CHECK_RADIUS;
_chaffNearby = _chaffNearby select {
    // 8 = radar blocking (bit 3)
    (([getNumber (configOf _x >> "weaponLockSystem"), 4] call ace_common_fnc_binarizeNumber) select 3)
    && { [_seeker, getPosASLVisual _x, _seekerAngle] call fza_hellfire_fnc_isTargetInSeekerCone }
    && { [_seeker, _x, false] call ace_missileguidance_fnc_checkLos }
};

private _perChaffChance = (RF_CM_PER_CHAFF_CHANCE * _chaffCoef) max 0 min 0.95;
private _chaffCount = count _chaffNearby;
private _combinedChance = 1 - ((1 - _perChaffChance) ^ _chaffCount);

(_chaffCount > 0) && { random 1 < _combinedChance }
