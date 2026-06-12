/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_arhSeekerUpdate
Description: Per-tick ARH seeker update for the AGM-114L. Returns the world
    position the missile guides towards this frame.
    seekerStateParams: [isActive, timeWhenActive, expectedTargetPos,
    calculatedSearchPos, lastTargetPollTime, lastKnownVelocity,
    lastTimeSeen, doesntHaveTarget, targetType, cachedSeekerAngle,
    dbsOffset, arhLockTypes]
Parameters:
    _args              - ACE guidance args array
    _seekerStateParams - ARH seeker state array
    _timestep          - Seconds since last call
Returns: World position [x,y,z]
Author: Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["", "_args", "_seekerStateParams", "", "_timestep"];
_args params ["_firedEH", "_launchParams", "", "_seekerParams", "_stateParams", "_targetData", "_navigationStateParams"];
_firedEH params ["_shooter","","","","","","_projectile"];
_launchParams params ["_lastTarget","","","",""];
_seekerParams params ["_seekerAngle", "", "_seekerMaxRange"];
_seekerStateParams params [
    "_isActive",
    "_timeWhenActive",
    "_expectedTargetPos",
    "_calculatedSearchPos",
    "_lastTargetPollTime",
    "_lastKnownVelocity",
    "_lastTimeSeen",
    "_doesntHaveTarget",
    "_targetType",
    ["_cachedSeekerAngle", -1],
    ["_dbsOffset", [0, 0, 0]],
    ["_arhLockTypes", []]
];

private _resolvedSeekerAngle = [_seekerAngle, _cachedSeekerAngle] select (_cachedSeekerAngle >= 0);

// Coast phase
if (!_isActive && { CBA_missionTime <= _timeWhenActive }) exitWith {
    _targetData set [2, (getPosASLVisual _projectile) distance _expectedTargetPos];
    (_expectedTargetPos vectorAdd _dbsOffset)
};

if (!_isActive) then {
    _seekerStateParams set [0, true];
    private _activationDist = (getPosASL _projectile) vectorDistance _calculatedSearchPos;
    _projectile setVariable ["fza_dbsFadeHalfDist", _activationDist * 0.5];
};

#define ARH_MIN_SCAN_RADIUS       50
#define ARH_MAX_SCAN_RADIUS       500
#define ARH_TERMINAL_RANGE        300
#define ARH_LOCK_LOSS_GRACE_PERIOD 1
#define STAGE_ATTACK_TERMINAL      4

private _target = objNull;
private _hadTarget = !_doesntHaveTarget;

// Direct-track
if (([_projectile, [getPosASL _lastTarget, speed _lastTarget, _lastTarget], true, _resolvedSeekerAngle] call fza_hellfire_fnc_arhTargetConstraint) # 1) then {
    _target = _lastTarget;
} else {
    
    private _lockLostTime = _projectile getVariable ["fza_lockLostTime", -1];
    if (_lockLostTime < 0 && _hadTarget) then {
        _lockLostTime = CBA_missionTime;
        _projectile setVariable ["fza_lockLostTime", _lockLostTime];
    };

    private _inGracePeriod = _lockLostTime >= 0 && { (CBA_missionTime - _lockLostTime) < ARH_LOCK_LOSS_GRACE_PERIOD };

    private _distMissileToSearch = (getPosASL _projectile) vectorDistance _calculatedSearchPos;

    if (!_inGracePeriod && _distMissileToSearch > ARH_TERMINAL_RANGE && _calculatedSearchPos isNotEqualTo [0, 0, 0]) then {

        // Adaptive poll: 2 Hz > 1500 m, 5 Hz 500-1500 m, 10 Hz < 500 m
        private _pollInterval = [[0.1, 0.2] select (_distMissileToSearch > 500), 0.5] select (_distMissileToSearch > 1500);

        if (CBA_missionTime - _lastTargetPollTime >= _pollInterval) then {
            _seekerStateParams set [4, CBA_missionTime];

            // Cone footprint: tan(halfAngle) * slantDist, rescaled so a seeker at
            // ARH_REFERENCE_SEEKER_ANGLE naturally reaches ARH_MAX_SCAN_RADIUS at
            // FCR_LIMIT_FORCE_LOBL_RANGE, then scales down/up from there
            private _slantDist  = _distMissileToSearch min FCR_LIMIT_FORCE_LOBL_RANGE;
            private _coneScale  = ARH_MAX_SCAN_RADIUS / (FCR_LIMIT_FORCE_LOBL_RANGE * tan (_cachedSeekerAngle / 2));
            private _coneRadius = (ARH_MIN_SCAN_RADIUS max (_slantDist * tan (_resolvedSeekerAngle / 2) * _coneScale)) min ARH_MAX_SCAN_RADIUS;

            private _searchRadius = if (_doesntHaveTarget) then {
                _coneRadius
            } else {
                linearConversion [
                    0, _coneRadius,
                    (CBA_missionTime - _lastTimeSeen) * vectorMagnitude _lastKnownVelocity,
                    ARH_MIN_SCAN_RADIUS, _coneRadius, false
                ]
            };

            private _searchClasses = _arhLockTypes;
            private _candidates = nearestObjects [ASLToAGL _calculatedSearchPos, _searchClasses, _searchRadius, false];

            private _secondaryTarget = objNull;
            private _index = 0;
            private _count = count _candidates;

            while {_index < _count && {isNull _target}} do {
                private _cand = _candidates # _index;

                if (([_projectile, [getPosASL _cand, speed _cand, _cand], true, _resolvedSeekerAngle] call fza_hellfire_fnc_arhTargetConstraint) # 1) then {
                    private _targTypeCompare = (_cand call BIS_fnc_objectType) # 1;
                    if (_targetType isEqualTo _targTypeCompare) then {
                        _target = _cand;
                    } else {
                        if (isNull _secondaryTarget) then {
                            _secondaryTarget = _cand;
                        };
                    };
                };

                _index = _index + 1;
            };

            if (isNull _target) then {
                _target = _secondaryTarget;
            };
        };
    };
};

if !(isNull _target) then {
    _projectile setVariable ["fza_lockLostTime", -1];

    private _centerOfObject    = getCenterOfMass _target;
    private _targetAdjustedPos = _target modelToWorldVisualWorld _centerOfObject;
    _expectedTargetPos = _targetAdjustedPos;

    _seekerStateParams set [3, _expectedTargetPos];
    _seekerStateParams set [5, velocity _target];
    _seekerStateParams set [6, CBA_missionTime];
    _seekerStateParams set [7, false];

    _targetData set [2, _projectile distance _target];
    _targetData set [3, velocity _target];

    _launchParams set [0, _target];

    if (_timestep > 0) then {
        private _acceleration = (velocity _target vectorDiff _lastKnownVelocity) vectorMultiply (1 / _timestep);
        _targetData set [4, _acceleration];
    };

    // Active radar lock: skip straight to terminal guidance rather than
    // waiting on the attack profile's climb/height-above-launcher gate.
    private _attackProfileStateParams = _stateParams # 2;
    if ((_attackProfileStateParams # 0) < STAGE_ATTACK_TERMINAL) then {
        _stateParams set [2, [STAGE_ATTACK_TERMINAL, 0, [getPosASL _projectile select 2, 0]]];
    };
} else {
    _projectile setMissileTarget objNull;
    _launchParams set [0, objNull];
    _seekerStateParams set [7, true];
};

private _dbsFadeHalfDist = _projectile getVariable ["fza_dbsFadeHalfDist", -1];
private _scaledOffset = if (_dbsFadeHalfDist > 0) then {
    private _positionOffset = [_expectedTargetPos, _calculatedSearchPos] select (isNull _target);
    private _distToSearch = (getPosASL _projectile) vectorDistance _positionOffset;
    private _scale = (((_distToSearch - _dbsFadeHalfDist) / _dbsFadeHalfDist) min 1) max 0;
    _dbsOffset vectorMultiply _scale
} else {
    _dbsOffset
};
private _returnPos = _expectedTargetPos vectorAdd _scaledOffset;

_targetData set [0, (getPosASLVisual _projectile) vectorFromTo _returnPos];
_seekerStateParams set [2, _expectedTargetPos];

_returnPos
