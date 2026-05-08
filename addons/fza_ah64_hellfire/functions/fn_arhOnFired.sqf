/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_arhOnFired
Description: Initialises the ARH seeker state at launch. Reads FCR NTS data,
    evaluates engagement constraints, computes TOF, and populates the ACE
    guidance state arrays that drive fn_arhSeekerUpdate each tick.
    seekerStateParams: [isActive, timeWhenActive, expectedTargetPos,
    calculatedSearchPos, lastTargetPollTime, lastKnownVelocity,
    lastTimeSeen, doesntHaveTarget, targetType, cachedSeekerAngle]
Parameters:
    _firedEH      - Full ACE fired-EH array
    _launchParams - ACE launch params (mutated in-place)
    _stateParams  - ACE state wrapper; index 1 holds seekerStateParams
Returns: Nothing
Author: Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_firedEH", "_launchParams", "", "", "_stateParams", "_targetData"];
_firedEH params ["_shooter","","","","","","_projectile"];
_stateParams params ["", "_seekerStateParams"];

private _heli = vehicle _shooter;

#define SCALE_METERS_KM 0.001

private _seekerAngle = getNumber (configFile >> "CfgAmmo" >> "fza_agm114l" >> "ace_missileguidance" >> "seekerAngle");

_heli getVariable "fza_ah64_fcrNts" params ["_targObj", "_targPos", "_fcrData"];

private _handoffSource = "FCR";
private _sight = [_heli, "fza_ah64_sight"] call fza_fnc_getSeatVariable;

if (_sight == SIGHT_TADS) then {
    _handoffSource = "TADS";
    _targPos = [0, 0, 0];
    private _handoffData = _heli getVariable ["fza_ah64_tadsRfHandoffData", []];
    if (_handoffData isEqualType [] && {count _handoffData >= 1}) then {
        _targPos = _handoffData # 0;
    };
    _targObj = _heli getVariable ["fza_ah64_tadsRfHandoffLoblTarget", objNull];
    if (!isNull _targObj) then { _targPos = getPosASL _targObj; };
};

private _targSpeed = [0, speed _targObj] select (!isNull _targObj);
private _loblCheckLima = [_heli, [_targPos, _targSpeed, _targObj], false, _seekerAngle] call fza_hellfire_fnc_arhTargetConstraint;
private _targetType = ["UNKNOWN", (_targObj call BIS_fnc_objectType) # 1] select (!isNull _targObj);

private _attackProfile       = "hellfire_lo";
private _calculatedImpactPos = [0, 0, 0];
private _calculatedSearchPos = [0, 0, 0];
private _timeToSearch        = 9999999;
private _timeToImpact        = 9999999;
private _isActive            = false;
private _dbsOffset           = [0, 0, 0];

if (_targPos isNotEqualTo [0, 0, 0]) then {
    _targetData set [2, (getPosASL _heli) distance _targPos];
    _targetData set [3, [0, 0, 0]];
    _targetData set [4, [0, 0, 0]];
};

if (_targPos isNotEqualTo [0, 0, 0]) then {
    // Time-of-flight lookup table: [range_km, tof_seconds]
    private _hellfireTOF = [[0,0],[1,3],[2,7],[3,10],[4,14],[5,19],[6,24],[7,29],[8,36],[9,44]];
    private _rangeKm     = (_targPos distance _heli) * SCALE_METERS_KM;
    private _rangeM      = _rangeKm * 1000;

    // Shorter engagements should avoid an excessive climb arc.
    _attackProfile = ["hellfire_hi", "hellfire_lo"] select (_rangeM <= 3500);

    _timeToImpact = ([_hellfireTOF, _rangeKm] call fza_fnc_linearInterp) # 1;
    _timeToSearch = ([_hellfireTOF, (_rangeKm - (FCR_LIMIT_FORCE_LOBL_RANGE * SCALE_METERS_KM))] call fza_fnc_linearInterp) # 1;
    _timeToSearch = _timeToSearch max 0;

    _calculatedSearchPos = _targPos;
    _calculatedImpactPos = _targPos;

    // DBS-style lateral bias only: keep standard attack profiles, just shape approach path.
    private _isStationary = _targSpeed < FCR_LIMIT_MOVING_MIN_SPEED_KMH;
    if (_isStationary && _rangeM > FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE) then {
        // DMS/DBS mode: wake seeker 20% sooner to begin terminal acquisition earlier.
        _timeToSearch = (_timeToSearch * 0.8) max 0;
        _calculatedSearchPos = _targPos;

        private _hPos     = getPosASL _heli;
        private _toTarget = vectorNormalized [(_targPos # 0) - (_hPos # 0), (_targPos # 1) - (_hPos # 1), 0];
        private _hFwd     = [sin (getDir _heli), cos (getDir _heli), 0];
        private _crossZ   = (_hFwd # 0) * (_toTarget # 1) - (_hFwd # 1) * (_toTarget # 0);
        private _perpDir  = if (_crossZ >= 0) then {
            [_toTarget # 1, -(_toTarget # 0), 0]   // target LEFT  -> offset RIGHT
        } else {
            [-(_toTarget # 1), _toTarget # 0, 0]   // target RIGHT -> offset LEFT
        };
        private _offsetDist = (_rangeM * 0.15) min 800;
        _dbsOffset = _perpDir vectorMultiply _offsetDist;
    };

    private _currentTof = _heli getVariable "fza_ah64_tofCountDown";
    _currentTof pushBack (_timeToImpact + CBA_missionTime);
    _heli setVariable ["fza_ah64_tofCountDown", _currentTof];
};

if (!(isNull _targObj) && _loblCheckLima # 1) then {
    _attackProfile = "hellfire";
    _isActive      = true;

    private _atkProfileState = _stateParams # 2;
    _atkProfileState pushBack 4;
    _atkProfileState pushBack 0;
    _atkProfileState pushBack [getPosASL _projectile select 2, 0];
};

[_heli] call fza_fcr_fnc_cycleNTS;

// Seeker state
_seekerStateParams set [0, _isActive];
_seekerStateParams set [1, CBA_missionTime + _timeToSearch];
_seekerStateParams set [2, _calculatedImpactPos];
_seekerStateParams set [3, _calculatedSearchPos];
_seekerStateParams set [4, 0];
_seekerStateParams set [5, [0, 0, 0]];
_seekerStateParams set [6, 0];
_seekerStateParams set [7, !_isActive];
_seekerStateParams set [8, _targetType];
_seekerStateParams set [9, _seekerAngle];
_seekerStateParams set [10, _dbsOffset];

_launchParams set [3, _attackProfile];
_launchParams set [0, _targObj];

if (!isNull _targObj) then {
    // Seed lock immediately at launch; seeker loop will keep it updated.
    _projectile setMissileTarget _targObj;
};

// Shot-at file
private _shotFcrData = [];
if (_handoffSource == "FCR") then {
    _shotFcrData = _fcrData;
};

[_heli, "", [dayTime, "HH:MM:SS"] call BIS_fnc_timeToString, _targPos, _shotFcrData] call fza_dms_fnc_addShotRF;
