/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_arhTargetConstraint
Description: Evaluates whether the ARH seeker can engage a target. Checks
    distance bands, seeker cone, and LOS.
Parameters:
    _seeker            - Seeker object (helicopter pre-launch or projectile)
    _targ              - [_targPos, _targSpeed, _targObj]
    _inFlight          - (Optional) true when called from seeker update [false]
    _cachedSeekerAngle - (Optional) Pre-read cone half-angle; -1 reads CfgAmmo
Returns: [canFire, startLobl]
Author: Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_seeker", "_targ", ["_inFlight", false], ["_cachedSeekerAngle", -1]];
_targ params ["_targPos", "_targSpeed", "_targObj"];

private _dist = _seeker distance _targPos;

private _seekerAngle = [getNumber (configFile >> "CfgAmmo" >> "fza_agm114l" >> "ace_missileguidance" >> "seekerAngle"), _cachedSeekerAngle] select (_cachedSeekerAngle >= 0);

private _inConstraints = [_seeker, _targPos, _seekerAngle] call fza_hellfire_fnc_isTargetInSeekerCone;
// Short-circuit: second checkLos only runs when the first returns false
private _canSee = [_seeker, _targObj, false] call ace_missileguidance_fnc_checkLos
               || [_seeker, _targObj, true]  call ace_missileguidance_fnc_checkLos;

if (_dist <= 500 && !_inFlight)       exitWith { [false, false] };
if (!_inConstraints)                   exitWith { [false, false] };

if (_targSpeed >= FCR_LIMIT_MOVING_MIN_SPEED_KMH && !_inFlight) exitWith {
    if (_dist >= FCR_LIMIT_MOVING_RANGE || !_canSee) exitWith { [false, false] };
    [true, true]
};

if (_dist <= FCR_LIMIT_FORCE_LOBL_RANGE)       exitWith { [_canSee, _canSee]  };
if (_dist <= FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE) exitWith { [true, _canSee]     };
if (_dist <= FCR_LIMIT_STATIONARY_RANGE)       exitWith { [true, false]       };

[false, false]
