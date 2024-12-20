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
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["", "_args", "_seekerStateParams", "", "_timestep"];
_args params ["_firedEH", "_launchParams", "", "_seekerParams", "_stateParams", "_targetData", "_navigationStateParams"];
_firedEH params ["_shooter","","","","","","_projectile"];
_launchParams params ["_target","","","",""];
_seekerParams params ["_seekerAngle", "", "_seekerMaxRange"];
_seekerStateParams params ["_isActive", "_timeWhenActive", "_expectedTargetPos", "_calulatedSearchPos", "_lastTargetPollTime", "_lastKnownVelocity", "_lastTimeSeen", "_doesntHaveTarget", "_targetType"];

#define ACTIVE_RADAR_MINIMUM_SCAN_AREA 50

drawIcon3D ["\a3\ui_f\data\IGUI\Cfg\Cursors\selectover_ca.paa", [1,0,1,1], _calulatedSearchPos vectorAdd [0, 0, 0], 0.75, 0.75, 0, "SEARCH POS", 1, 0.025, "TahomaB"];

if (!_isActive && { CBA_missionTime  <= _timeWhenActive }) exitwith {
    _expectedTargetPos
};

if !_isActive then {
    _seekerStateParams set [0, true]; // _isactive
    systemchat "live";
};

if ((_lastTargetPollTime + (1 / 7)) - CBA_missionTime < 0) then {
    systemchat "GUIDING";
    _seekerStateParams set [4, CBA_missionTime];
    private _searchPos = _calulatedSearchPos;
    if (_searchPos isEqualTo [0, 0, 0]) exitwith {};
    _target = objNull;
    private _distanceToExpectedTarget = FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE min ((getPosASL _projectile) vectorDistance _searchPos);

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
    private _nearestObjects = nearestObjects [ASLtoAGL _searchPos, ["all"], _seekerBaseRadiusAdjusted, false];
    _nearestObjects = _nearestObjects select {([_projectile, [getpos _x, speed _x, _x], true] call fza_hellfire_fnc_limaLoblCheck)#1};
    // Select closest object to the expected position to be the current radar target
    if (_nearestObjects isEqualTo []) exitWith {
        _projectile setMissileTarget objNull;
        _expectedTargetPos
    };

    private _primaryTargets = _nearestObjects select {
        _targTypeCompare = (_x call BIS_fnc_objectType)#1;
        (_targetType isEqualTo _targTypeCompare)
    };
    private _secondaryTargets = _nearestObjects - _primaryTargets;
    _primaryTargets = [_primaryTargets, [], {_x distance _searchPos}, "ASCEND"] call BIS_fnc_sortBy;
    _secondaryTargets = [_secondaryTargets, [], {_x distance _searchPos}, "ASCEND"] call BIS_fnc_sortBy;
    systemchat str _primaryTargets;
    systemchat str _secondaryTargets;

    if (_primaryTargets isNotEqualTo []) then {
        _target = _primaryTargets#0
    } else {
        if (_secondaryTargets isNotEqualTo []) then {
            _target = _secondaryTargets#0
            //_seekerStateParams set [8, (_target call BIS_fnc_objectType)#1]; // Might cause unexpected behaviour in terminal, uncomment in future if needed
        };
    };
};

_projectile setMissileTarget _target;

if !(isNull _target) then {
    private _centerOfObject = getCenterOfMass _target;
    private _targetAdjustedPos = _target modelToWorldVisualWorld _centerOfObject;
    _expectedTargetPos = _targetAdjustedPos;

    _seekerStateParams set [3, _expectedTargetPos];
    _seekerStateParams set [5, velocity _target];
    _seekerStateParams set [6, CBA_missionTime];
    _seekerStateParams set [7, false];

    _targetData set [2, _projectile distance _target];
    _targetData set [3, velocity _target];

    if (_timestep != 0) then {
        private _acceleration = ((velocity _target) vectorDiff _lastKnownVelocity) vectorMultiply (1 / _timestep);
        _targetData set [4, _acceleration];
    };
} else {
    _launchParams set [0, objnull];
    _seekerStateParams set [7, true];
};

_targetData set [0, (getPosASLVisual _projectile) vectorFromTo _expectedTargetPos];
_seekerStateParams set [2, _expectedTargetPos];

_expectedTargetPos