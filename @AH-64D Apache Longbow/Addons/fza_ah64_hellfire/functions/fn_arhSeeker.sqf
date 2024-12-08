/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_arhSeeker

Description:
    Using data available upon launch, returns the targets expected positon || caluclated position if LOBL on target
    utilises Ace millimeterWaveRadar function rewritten to fit purpose

Parameters:
    _shooter - The helicopter that shot the missile
    _args - contains all of the main following paramaters
    _firedEH - the intirety of the fired eh event handler output
    _stateParams - contains the current hellfire guidance state
    _projectile - the projectile object
    _seekerAngle - cfg seeker max angle
    _seekerMaxRange - cfg seeker max range

Returns:

Examples:

Author:
    Snow(Dryden), ACE3
---------------------------------------------------------------------------- */
params ["", "_args", "_seekerStateParams", "", "_timestep"];
_args params ["_firedEH", "_launchParams", "", "_seekerParams", "_stateParams", "_targetData", "_navigationStateParams"];
_stateParams params ["", "", "_attackProfileStateParams"];
_firedEH params ["_shooter","","","","","","_projectile"];
_launchParams params ["_target","","","",""];
_seekerParams params ["_seekerAngle", "", "_seekerMaxRange"];
_seekerStateParams params ["_isActive", "_activeRadarEngageDistance", "_timeWhenActive", "_expectedTargetPos", "_lastTargetPollTime", "_shooterHasRadar", "_wasActive", "_lastKnownVelocity", "_lastTimeSeen", "_doesntHaveTarget", "_lockTypes", "_targetType"];

systemchat str _expectedTargetPos;

if (_isActive || { CBA_missionTime >= _timeWhenActive }) then {
    if !(_isActive) then {
        _seekerStateParams set [0, true]; // _isactive
    };
    if !(_wasActive) then {
        _seekerStateParams set [6, true];  //_wasActive
    };

    if ((_lastTargetPollTime + (1 / 7)) - CBA_missionTime < 0) then {

        private _newScanTargets  = nearestObjects [_expectedTargetPos, ["land","air","ship"], 500];
        private _validTargets    = _newScanTargets apply {
            if ((([_projectile, [getpos _x, speed _x, _x], true] call fza_hellfire_fnc_limaLoblCheck) # 1)) then {
                _x
            };
        };

        private _primaryTargets = _validTargets select {
            private _targTypeCompare = _x call BIS_fnc_objectType;
            (_targetType isEqualTo _targTypeCompare)
        };
        private _secondaryTargets = _primaryTargets - _validTargets;
        
        if (_primaryTargets isNotEqualTo []) then {
            _target = ([_primaryTargets, _expectedTargetPos] call BIS_fnc_nearestPosition);
        } else {
            if (_secondaryTargets isNotEqualTo []) then {
                _target = ([_secondaryTargets, _expectedTargetPos] call BIS_fnc_nearestPosition);
            };
        };

    };
};

if !(isNull _target) then {
    private _centerOfObject = getCenterOfMass _target;
    private _targetAdjustedPos = _target modelToWorldVisualWorld _centerOfObject;
    _expectedTargetPos = _targetAdjustedPos;

    _seekerStateParams set [7, velocity _target];
    _seekerStateParams set [8, CBA_missionTime];
    _seekerStateParams set [9, false];

    _targetData set [2, _projectile distance _target];
    _targetData set [3, velocity _target];

    if (_timestep != 0) then {
        private _acceleration = ((velocity _target) vectorDiff _lastKnownVelocity) vectorMultiply (1 / _timestep);
        _targetData set [4, _acceleration];
    };
};

_targetData set [0, (getPosASLVisual _projectile) vectorFromTo _expectedTargetPos];

//_seekerStateParams set [3, _expectedTargetPos]; // _expectedTargetPos
_launchParams set [0, _target];
_expectedTargetPos