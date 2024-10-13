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
_seekerStateParams params ["_isActive", "_activeRadarEngageDistance", "_timeWhenActive", "_expectedTargetPos", "_lastTargetPollTime", "_shooterHasRadar", "_wasActive", "_lastKnownVelocity", "_lastTimeSeen", "_doesntHaveTarget", "_lockTypes"];

#define ACTIVE_RADAR_MINIMUM_SCAN_AREA 50

if (_isActive || { CBA_missionTime >= _timeWhenActive }) then {
    if !(_isActive) then {
        _seekerStateParams set [0, true];
    };
    if !(_wasActive) then {
        _seekerStateParams set [6, true];
    };

    // Internal radar homing
    // For performance reasons only poll for target every so often instead of each frame
    if ((_lastTargetPollTime + (1 / 7)) - CBA_missionTime < 0) then {
        private _searchPos = _expectedTargetPos;
        if (_searchPos isEqualTo [0, 0, 0]) then {
            _seekerStateParams set [9, true];
            // no target pos - shot without lock. Have the missile's radar search infront of it on the ground
            _searchPos = (getPosASL _projectile) vectorAdd (_projectile vectorModelToWorld [0, _seekerMaxRange, -((getPos _projectile)#2)]);
        };

        _target = objNull;
        _lastTargetPollTime = CBA_missionTime;
        _seekerStateParams set [4, _lastTargetPollTime];
        private _distanceToExpectedTarget = _seekerMaxRange min ((getPosASL _projectile) vectorDistance _searchPos);

        // Simulate how much the seeker can see at the ground
        private _projDir = vectorDir _projectile;
        private _projYaw = getDir _projectile;
        private _rotatedYaw = (+(_projDir select 0) * sin _projYaw) + (+(_projDir select 1) * cos _projYaw);
        if (_rotatedYaw isEqualTo 0) then { _rotatedYaw = 0.001 };
        private _projPitch = atan ((_projDir select 2) / _rotatedYaw);
        private _a1 = abs _projPitch;
        private _a2 = 180 - ((_seekerAngle / 3) + _a1);
        private _seekerBaseRadiusAtGround = ACTIVE_RADAR_MINIMUM_SCAN_AREA max (_distanceToExpectedTarget / sin(_a2) * sin(_seekerAngle / 2));
        private _seekerBaseRadiusAdjusted = linearConversion [0, _seekerBaseRadiusAtGround, (CBA_missionTime - _lastTimeSeen) * vectorMagnitude _lastKnownVelocity, ACTIVE_RADAR_MINIMUM_SCAN_AREA, _seekerBaseRadiusAtGround, false];
        if (_doesntHaveTarget) then {
            _seekerBaseRadiusAdjusted = _seekerBaseRadiusAtGround;
        };
        // Look in front of seeker for any targets
        private _nearestObjects = nearestObjects [ASLtoAGL _searchPos, _lockTypes, _seekerBaseRadiusAdjusted, false];
        _nearestObjects = _nearestObjects apply {
            if (([_projectile, [getpos _x, speed _x, _x], true] call fza_hellfire_fnc_limaLoblCheck) # 1) then {
                _x
            } else {
                objNull
            };
        };
        _nearestObjects = _nearestObjects select { !isNull _x };
        // Select closest object to the expected position to be the current radar target
        if (_nearestObjects isEqualTo []) exitWith {
            _projectile setMissileTarget objNull;
            _seekerStateParams set [3, _searchPos];
            _searchPos
        };
        private _closestDistance = _seekerBaseRadiusAtGround;
        {
            if ((_x distance2d _searchPos) < _closestDistance) then {
                _closestDistance = _x distance2d _searchPos;
                _target = _x;
            };
        } forEach _nearestObjects;

        _expectedTargetPos = _searchPos;
    };

    _projectile setMissileTarget _target;
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

_seekerStateParams set [3, _expectedTargetPos];
_launchParams set [0, _target];
_expectedTargetPos