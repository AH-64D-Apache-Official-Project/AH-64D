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
params ["_firedEH", "_launchParams", "", "", "_stateParams"];
_firedEH params ["_shooter","","","","","","_projectile"];
_stateParams params ["", "_seekerStateParams"];

private _heli = vehicle _shooter;

#define SCALE_METERS_KM 0.001

private _seekerAngle = getNumber (configFile >> "CfgAmmo" >> "fza_agm114l" >> "ace_missileguidance" >> "seekerAngle");

_heli getVariable "fza_ah64_fcrNts" params ["_targObj", "_targPos", "_fcrData"];

private _loblCheckLima     = [_heli, [getPos _targObj, speed _targObj, _targObj], true,  _seekerAngle] call fza_hellfire_fnc_arhTargetConstraint;
private _loblCheckAircraft = [_heli, [getPos _targObj, speed _targObj, _targObj], false, _seekerAngle] call fza_hellfire_fnc_arhTargetConstraint;
private _targetType        = (_targObj call BIS_fnc_objectType) # 1;

private _attackProfile       = "hellfire_hi";
private _calculatedImpactPos = [0, 0, 0];
private _calculatedSearchPos = [0, 0, 0];
private _timeToSearch        = 9999999;
private _timeToImpact        = 9999999;
private _targetVel           = [0, 0, 0];
private _isActive            = false;

if (!(isNull _targObj) && _loblCheckAircraft # 1) then {
    _targPos   = getPosASL _targObj;
    _targetVel = velocity _targObj;
} else {
    _targObj = objNull;
};

if (!isNil "_targObj") then {
    // Time-of-flight lookup table: [range_km, tof_seconds]
    private _hellfireTOF = [[0,0],[1,3],[2,7],[3,10],[4,14],[5,19],[6,24],[7,29],[8,36],[9,44]];
    private _rangeKm     = (_targPos distance _heli) * SCALE_METERS_KM;

    _timeToImpact = ([_hellfireTOF, _rangeKm] call fza_fnc_linearInterp) # 1;
    _timeToSearch = ([_hellfireTOF, (_rangeKm - (FCR_LIMIT_FORCE_LOBL_RANGE * SCALE_METERS_KM))] call fza_fnc_linearInterp) # 1;

    _calculatedSearchPos = _targPos vectorAdd (_targetVel vectorMultiply _timeToSearch);
    _calculatedImpactPos = _targPos vectorAdd (_targetVel vectorMultiply _timeToImpact);

    private _currentTof = _heli getVariable "fza_ah64_tofCountDown";
    _currentTof pushBack (_timeToImpact + CBA_missionTime);
    _heli setVariable ["fza_ah64_tofCountDown", _currentTof];
};

if (!(isNull _targObj) && _loblCheckLima # 1) then {
    _attackProfile = "hellfire";
    _isActive      = true;
};

[_heli] call fza_fcr_fnc_cycleNTS;

// Seeker state
_seekerStateParams set [0, _isActive];
_seekerStateParams set [1, CBA_missionTime + _timeToSearch];
_seekerStateParams set [2, _calculatedImpactPos];
_seekerStateParams set [3, _calculatedSearchPos];
_seekerStateParams set [4, 0];
_seekerStateParams set [5, _targetVel];
_seekerStateParams set [6, 0];
_seekerStateParams set [7, !_isActive];
_seekerStateParams set [8, _targetType];
_seekerStateParams set [9, _seekerAngle];

_launchParams set [3, _attackProfile];
_launchParams set [0, objNull];

// Shot-at file
_fcrData params ["_pos", "_type", "_moving", "_target", "_aziAngle", "_elevAngle", "_range"];
private _unitType   = "UNK";
private _unitStatus = "LOAL";

if (_fcrData isNotEqualTo []) then {
    switch (_type) do {
        case FCR_TYPE_UNKNOWN:    { _unitType = "UNK";   };
        case FCR_TYPE_WHEELED:    { _unitType = "WHEEL"; };
        case FCR_TYPE_HELICOPTER: { _unitType = "HELI";  };
        case FCR_TYPE_FLYER:      { _unitType = "FLYER"; };
        case FCR_TYPE_TRACKED:    { _unitType = "TRACK"; };
        case FCR_TYPE_ADU:        { _unitType = "ADU";   };
    };

    if ((_moving && (_range >= FCR_LIMIT_MIN_RANGE && _range <= FCR_LIMIT_MOVING_RANGE)) || _unitType == "FLYER") then {
        _unitStatus = "MOVE";
    } else {
        if (_range >= FCR_LIMIT_MIN_RANGE && _range <= FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE) then {
            _unitStatus = "LOBL";
        };
        if (_range > FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE && _range <= FCR_LIMIT_STATIONARY_RANGE) then {
            _unitStatus = "LOAL";
        };
    };
};

private _ident = ["FCR", _unitType, _unitStatus] joinString "_";
[_heli, _ident, [dayTime, "HH:MM:SS"] call BIS_fnc_timeToString, _targPos] call fza_dms_fnc_addShotRF;
