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
_launchParams params ["","_targetLaunchParams"];
_targetLaunchParams params ["_target"];

#define SCALE_METERS_KM 0.001
#define SCALE_KM_TOF 4

private _heli           = vehicle _shooter;
private _targinfo       = _heli getVariable "fza_ah64_fcrNts";
private _currentTof     = _heli getVariable "fza_ah64_tofCountDown";
private _target         = _targinfo #0;
private _targetPos      = _targinfo #1;

if !(_target isKindOf "AllVehicles") then {
    _target = nil;
};
_launchParams set [0, _target];
_projectile setMissileTarget objNull; // to emulate a no launch warning

private _projectileConfig = configOf _projectile;
private _config = _projectileConfig >> "ace_missileguidance";

private _isActive = false;
private _activeRadarDistance = [_config >> "activeRadarEngageDistance", "NUMBER", 500] call CBA_fnc_getConfigEntry;
private _projectileThrust = [_projectileConfig >> "thrust", "NUMBER", 0] call CBA_fnc_getConfigEntry;
private _projectileThrustTime = [_projectileConfig >> "thrustTime", "NUMBER", 0] call CBA_fnc_getConfigEntry;

private _lockTypes = [_config >> "lockableTypes", "ARRAY", ["Air", "LandVehicle", "Ship"]] call CBA_fnc_getConfigEntry;

private _velocityAtImpact = _projectileThrust * _projectileThrustTime;
private _timeToActive = 0;
if (!isNil "_target") then {
    private _distanceUntilActive = (((getPosASL _shooter) vectorDistance (getPosASL _target)) - _activeRadarDistance);
    _timeToActive = 0 max (_distanceUntilActive / _velocityAtImpact);
    _currentTof pushBack (cba_missiontime + (_targetPos distance _heli) * SCALE_METERS_KM * SCALE_KM_TOF);
    _heli setvariable ["fza_ah64_tofCountDown", _currentTof];
};

if (isNil "_target") then {
    _timeToActive = 999;
    _isActive = false;
    _target = objNull;
};

//Dir trajectory ON LOBL
private _loblCheckLima  = [_heli, [getpos _target, speed _target, _target]] call fza_hellfire_fnc_limaLoblCheck;
private _attackProfile = "hellfire_hi";
if (_loblCheckLima #1) then {
    _attackProfile = "hellfire";
    _isActive = true;
};
//Cycle Radar targets
[_heli] call fza_fcr_fnc_cycleNTS;
_launchParams set [3, _attackProfile];

_seekerStateParams set [0, _isActive];
_seekerStateParams set [1, _activeRadarDistance];
_seekerStateParams set [2, CBA_missionTime + _timeToActive];
_seekerStateParams set [3, _targetPos];
_seekerStateParams set [4, CBA_missionTime];
_seekerStateParams set [5, true];
_seekerStateParams set [6, false];
_seekerStateParams set [7, [0, 0, 0]];
_seekerStateParams set [8, CBA_missionTime];
_seekerStateParams set [9, isNull _target];
_seekerStateParams set [10, _lockTypes];