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
params ["_firedEH", "_launchParams", "", "", "_stateParams"];
_firedEH params ["_shooter","","","","","","_projectile"];
_stateParams params ["", "_seekerStateParams"];

#define SCALE_METERS_KM 0.001
#define SCALE_KM_TOF 4

private _heli           = vehicle _shooter;
private _targinfo       = _heli getVariable "fza_ah64_fcrNts";
private _currentTof     = _heli getVariable "fza_ah64_tofCountDown";
private _targObj        = _targinfo #0;
private _targPos        = _targinfo #1;
private _targetType     = _targobj call BIS_fnc_objectType;
private _loblCheckLima  = [_heli, [getpos _targObj, speed _targObj, _targObj]] call fza_hellfire_fnc_limaLoblCheck;
private _expectedTargetPos = [0,0,0];

if (!(isNull _targObj) && _loblCheckLima #1) then {
    _targPos = getposasl _targObj;
} else {
    _targObj = Objnull;
};

if (!isNil "_targObj") then {
    private _hellfireTOF = [[0, 1],[1, 3],[2, 7],[3, 10],[4, 14],[5, 19],[6, 24],[7, 29],[8, 36],[9, 44]];
    private _timeUntilImpact = ([_hellfireTOF, (_targPos distance _heli) * SCALE_METERS_KM] call fza_fnc_linearInterp)#1;
    _expectedTargetPos = _targPos vectorAdd (velocity _targObj vectorMultiply _timeUntilImpact);
    _timeToActive =  ([_hellfireTOF, ((_expectedTargetPos distance _heli) - 2000) * SCALE_METERS_KM] call fza_fnc_linearInterp)#1;;
    _currentTof pushBack (_timeUntilImpact + CBA_missionTime);
    _heli setvariable ["fza_ah64_tofCountDown", _currentTof];
};

if (_projectile distance _targPos < 2000) then {
    _seekerStateParams set [0, _targObj];
} else {
    _seekerStateParams set [0, objnull];
};

if (_loblCheckLima#1) then {
    _attackProfile = "hellfire";
    _isActive = true;
    _targetVel = velocity _targObj;
};

_seekerStateParams set [0, _isActive];
_seekerStateParams set [1, _activeRadarDistance];
_seekerStateParams set [2, (CBA_missionTime + _timeToActive)];
_seekerStateParams set [3, _expectedTargetPos];
_seekerStateParams set [4, CBA_missionTime];
_seekerStateParams set [5, true];
_seekerStateParams set [6, false];
_seekerStateParams set [7, _targetVel];
_seekerStateParams set [8, _lastScanTime];
_seekerStateParams set [9, !_isActive];
_seekerStateParams set [10, _lockTypes];
_seekerStateParams set [11, _target call BIS_fnc_objectType];

_launchParams set [0, _targObj];
_launchParams set [3, _attackProfile];