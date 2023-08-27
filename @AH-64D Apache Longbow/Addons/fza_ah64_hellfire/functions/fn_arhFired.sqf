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
private _loblCheckLima  = [_heli, [getpos _targObj, "", speed _targObj, _targObj]] call fza_hellfire_fnc_limaLoblCheck;

if (!(isNull _targObj) && _loblCheckLima #1) then {
    _targPos = getposasl _targObj;
} else {
    _targObj = Objnull;
};

//Cycle Radar targets
[_heli] call fza_fnc_targetingSensorCycle;

//Dir trajectory at close range
private _attackProfile = "hellfire_hi";
if (_loblCheckLima #1) then {
    _attackProfile = "hellfire";
    _currentTof pushBack (cba_missiontime + (_targPos distance _heli) * SCALE_METERS_KM * SCALE_KM_TOF);
    _heli setvariable ["fza_ah64_tofCountDown", _currentTof];
};

if (_projectile distance _targPos < 2000) then {
    _seekerStateParams set [0, _targObj];
} else {
    _seekerStateParams set [0, objnull];
};

_launchParams set [3, _attackProfile];
_seekerStateParams set [1, _targPos];
_seekerStateParams set [2, _targetType];
_seekerStateParams set [3, _loblCheckLima #1];
_seekerStateParams set [4, 0];