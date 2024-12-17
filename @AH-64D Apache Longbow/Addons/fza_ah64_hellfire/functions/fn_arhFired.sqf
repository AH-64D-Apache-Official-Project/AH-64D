/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_arhFired

Description:
    Sets the seeker params for our custom ARH hellfire seeker head

Parameters:
    _firedEH - the intirety of the fired eh event handler output
    _stateParams - contains an array of custom hellfire to be passed to ace [Target object, Target position, Target type, Lima Lobl StartLobl]
    _shooter - the Apache 
    _projectile - the projectile object
    _targetpos - Target position at launch
    _launchPos - Apaches position at launch

Returns:
    Nothing

Examples:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_firedEH", "_launchParams", "", "", "_stateParams"];
_firedEH params ["_shooter","","","","","","_projectile"];
_stateParams params ["", "_seekerStateParams"];

private _heli = vehicle _shooter;

#define SCALE_METERS_KM 0.001
#define SCALE_KM_TOF 4

_heli getVariable "fza_ah64_fcrNts" params ["_targObj","_targPos"];
private _loblCheckLima = [_heli, [getpos _targObj, speed _targObj, _targObj], true] call fza_hellfire_fnc_limaLoblCheck;
private _loblCheckAircraft = [_heli, [getpos _targObj, speed _targObj, _targObj]] call fza_hellfire_fnc_limaLoblCheck;
private _targetType = (_targObj call BIS_fnc_objectType)#1;

private _attackProfile = "hellfire_hi";
private _calulatedImpactPos = [0,0,0];
private _calulatedSearchPos = [0,0,0];
private _timeToSearch = 9999999;
private _timeToimpact = 9999999;
private _targetVel = [0,0,0];
private _isActive = false;

if (!(isNull _targObj) && _loblCheckAircraft #1) then {
    _targPos = getposasl _targObj;
    _targetVel = velocity _targObj;
} else {
    _targObj = Objnull;
};

if (!isNil "_targObj") then {
    private _hellfireTOF = [[0, 0],[1, 3],[2, 7],[3, 10],[4, 14],[5, 19],[6, 24],[7, 29],[8, 36],[9, 44]];
    private _timeUntilImpact = ([_hellfireTOF, (_targPos distance _heli) * SCALE_METERS_KM] call fza_fnc_linearInterp)#1;
    _timeToSearch = ([_hellfireTOF, ((_targPos distance _heli) - FCR_LIMIT_LOAL_LOBL_SWITCH_RANGE) * SCALE_METERS_KM] call fza_fnc_linearInterp)#1;
    _timeToimpact = ([_hellfireTOF, (_targPos distance _heli) * SCALE_METERS_KM] call fza_fnc_linearInterp)#1;
    _calulatedSearchPos = _targPos vectorAdd (_targetVel vectorMultiply _timeToSearch);
    _calulatedImpactPos = _targPos vectorAdd (_targetVel vectorMultiply _timeToimpact);
    private _currentTof = _heli getVariable "fza_ah64_tofCountDown";
    _currentTof pushBack (_timeUntilImpact + CBA_missionTime);
    _heli setvariable ["fza_ah64_tofCountDown", _currentTof];
};

if (!(isNull _targObj) && _loblCheckLima #1) then {
    _attackProfile = "hellfire";
    _isActive = true;
};

//Cycle Radar targets
[_heli] call fza_fcr_fnc_cycleNTS;


_seekerStateParams set [0, _isActive];
_seekerStateParams set [1, (CBA_missionTime + _timeToSearch)];
_seekerStateParams set [2, _calulatedImpactPos];
_seekerStateParams set [3, _calulatedSearchPos];
_seekerStateParams set [4, 0];
_seekerStateParams set [5, _targetVel];
_seekerStateParams set [6, 0];
_seekerStateParams set [7, !_isActive];
_seekerStateParams set [8, _targetType];
_launchParams set [3, _attackProfile];

_projectile setvariable ["fza_ah64_SeekerstateData", _seekerStateParams];