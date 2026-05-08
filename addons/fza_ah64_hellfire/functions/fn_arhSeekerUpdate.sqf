/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_arhSeekerUpdate
Description: Per-tick ARH seeker update for the AGM-114L. Returns the world
    position the missile guides towards this frame.
    seekerStateParams: [isActive, timeWhenActive, expectedTargetPos,
    calculatedSearchPos, lastTargetPollTime, lastKnownVelocity,
    lastTimeSeen, doesntHaveTarget, targetType, cachedSeekerAngle,
    dbsOffset, lastCmCheckTime, lastDecoyTime]
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
    ["_lastCmCheckTime", -1],
    ["_lastDecoyTime", -1]
];

private _resolvedSeekerAngle = [_seekerAngle, _cachedSeekerAngle] select (_cachedSeekerAngle >= 0);

// Coast phase
if (!_isActive && { CBA_missionTime <= _timeWhenActive }) exitWith {
    _targetData set [2, (getPosASLVisual _projectile) distance _expectedTargetPos];
    (_expectedTargetPos vectorAdd _dbsOffset)
};

if (!_isActive) then {
    _seekerStateParams set [0, true];
    _dbsOffset = [0, 0, 0];
    _seekerStateParams set [10, _dbsOffset];
};

#define ARH_MIN_SCAN_RADIUS  50
#define ARH_TERMINAL_RANGE   300

private _target = objNull;
private _canReacquire = (CBA_missionTime - _lastDecoyTime) >= RF_REACQUIRE_DELAY;

// Direct-track
if (_canReacquire && {([_projectile, [getPosASL _lastTarget, speed _lastTarget, _lastTarget], true, _resolvedSeekerAngle] call fza_hellfire_fnc_arhTargetConstraint) # 1}) then {
    _target = _lastTarget;
} else {
    if (!_canReacquire) exitWith {};

    private _distMissileToSearch = (getPosASL _projectile) vectorDistance _calculatedSearchPos;

    if (_distMissileToSearch > ARH_TERMINAL_RANGE && _calculatedSearchPos isNotEqualTo [0, 0, 0]) then {

        // Adaptive poll: 2 Hz > 1500 m, 5 Hz 500-1500 m, 10 Hz < 500 m
        private _pollInterval = [[0.1, 0.2] select (_distMissileToSearch > 500), 0.5] select (_distMissileToSearch > 1500);

        if (CBA_missionTime - _lastTargetPollTime >= _pollInterval) then {
            _seekerStateParams set [4, CBA_missionTime];

            // Cone footprint: tan(halfAngle) * slantDist, capped at FCR_LIMIT_FORCE_LOBL_RANGE
            private _slantDist    = _distMissileToSearch min FCR_LIMIT_FORCE_LOBL_RANGE;
            private _coneRadius   = ARH_MIN_SCAN_RADIUS max (_slantDist * tan (_resolvedSeekerAngle / 2));

            private _searchRadius = if (_doesntHaveTarget) then {
                _coneRadius
            } else {
                linearConversion [
                    0, _coneRadius,
                    (CBA_missionTime - _lastTimeSeen) * vectorMagnitude _lastKnownVelocity,
                    ARH_MIN_SCAN_RADIUS, _coneRadius, false
                ]
            };

            // Type-aware class filter: sky targets use Air; ground targets use config-driven list
            private _searchClasses = getArray (configFile >> "CfgAmmo" >> "fza_agm114l" >> "ace_missileguidance" >> "fza_arhLockTypes");

            private _candidates = nearestObjects [ASLToAGL _calculatedSearchPos, _searchClasses, _searchRadius, false];

            _candidates = _candidates select {
                private _radarSig  = getNumber (configOf _x >> "radarTargetSize");
                if (_radarSig <= 0) then { _radarSig = 1.0 };
                private _normRange = ((_x distance (ASLToAGL _calculatedSearchPos)) / FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE) min 1;
                private _detectionProb = _radarSig ^ (1 + _normRange);
                (random 1 <= _detectionProb) && {
                    ([_projectile, [getPosASL _x, speed _x, _x], true, _resolvedSeekerAngle] call fza_hellfire_fnc_arhTargetConstraint) # 1
                }
            };

            if (_candidates isNotEqualTo []) then {
                private _primaryTargets = _candidates select {
                    private _targTypeCompare = (_x call BIS_fnc_objectType) # 1;
                    _targetType isEqualTo _targTypeCompare
                };
                private _secondaryTargets = _candidates - _primaryTargets;

                if (_primaryTargets isNotEqualTo []) then {
                    _target = [_primaryTargets,   [], { _x distance _calculatedSearchPos }, "ASCEND"] call BIS_fnc_sortBy select 0;
                } else {
                    if (_secondaryTargets isNotEqualTo []) then {
                        _target = [_secondaryTargets, [], { _x distance _calculatedSearchPos }, "ASCEND"] call BIS_fnc_sortBy select 0;
                    };
                };
            };
        };
    };
};

if !(isNull _target) then {// Chaff defeat check
    private _chaffCoef = missionNamespace getVariable ["ace_missileguidance_chaffEffectivenessCoef", 1.0];
    if ((CBA_missionTime - _lastCmCheckTime) >= RF_CM_CHECK_INTERVAL_SEEKER) then {
        _seekerStateParams set [11, CBA_missionTime];

        private _chaffDefeated = [_projectile, _target, _resolvedSeekerAngle, _chaffCoef] call fza_hellfire_fnc_checkChaffDefeat;
        if (_chaffDefeated) then {
            _target = objNull;
            _seekerStateParams set [7, true];
            _seekerStateParams set [12, CBA_missionTime];
        };
    };
};

if !(isNull _target) then {
    private _centerOfObject    = getCenterOfMass _target;
    private _targetAdjustedPos = _target modelToWorldVisualWorld _centerOfObject;
    _expectedTargetPos = _targetAdjustedPos;

    _seekerStateParams set [3, _expectedTargetPos];
    _seekerStateParams set [5, velocity _target];
    _seekerStateParams set [6, CBA_missionTime];
    _seekerStateParams set [7, false];

    // On lock, remove lateral bias so terminal homing is direct to target.
    _dbsOffset = [0, 0, 0];
    _seekerStateParams set [10, _dbsOffset];

    _targetData set [2, _projectile distance _target];
    _targetData set [3, velocity _target];

    _launchParams set [0, _target];

    // Publish active missile lock to vanilla threat systems.
    _projectile setMissileTarget _target;

    if (_timestep > 0) then {
        private _acceleration = (velocity _target vectorDiff _lastKnownVelocity) vectorMultiply (1 / _timestep);
        _targetData set [4, _acceleration];
    };
} else {
    _projectile setMissileTarget objNull;
    _launchParams set [0, objNull];
    _seekerStateParams set [7, true];
};

private _returnPos = _expectedTargetPos vectorAdd _dbsOffset;

_targetData set [0, (getPosASLVisual _projectile) vectorFromTo _returnPos];
_seekerStateParams set [2, _expectedTargetPos];

_returnPos
