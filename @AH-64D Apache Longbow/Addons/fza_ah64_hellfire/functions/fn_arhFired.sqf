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
_launchParams params ["",""];

#define SCALE_METERS_KM 0.001

private _heli           = vehicle _shooter;
private _targinfo       = _heli getVariable "fza_ah64_fcrNts";
private _currentTof     = _heli getVariable "fza_ah64_tofCountDown";
private _lastScanState  = _heli getVariable "fza_ah64_fcrLastScan";
private _lastScanTime   = _lastScanState #2;
private _target         = _targinfo #0;
private _targetPos      = _targinfo #1;
private _attackProfile  = "hellfire_hi";
private _isActive       = false;
private _timeToActive   = 0;
private _targetVel      = [0,0,0];

private _projectileConfig = configOf _projectile;
private _config = _projectileConfig >> "ace_missileguidance";
private _activeRadarDistance = [_config >> "activeRadarEngageDistance", "NUMBER", 500] call CBA_fnc_getConfigEntry;
private _lockTypes = [_config >> "lockableTypes", "ARRAY", ["Air", "LandVehicle", "Ship"]] call CBA_fnc_getConfigEntry;
private _velocityAtImpact = 380;
private _expectedTargetPos = [0,0,0];

if (!isNil "_target") then {
    private _timeUntilImpact = (_targetPos distance _projectile) / _velocityAtImpact;
    _expectedTargetPos = _targetPos vectorAdd (velocity _target vectorMultiply _timeUntilImpact);

    private _distanceUntilActive = (((getPosASL _shooter) vectorDistance _expectedTargetPos) - _activeRadarDistance);
    _timeToActive = 0 max (_distanceUntilActive / _velocityAtImpact);

    private _hellfireTOF = [[0, 1],[1, 3],[2, 7],[3, 10],[4, 14],[5, 19],[6, 24],[7, 29],[8, 36],[9, 44]];
    _currentTof pushBack (([_hellfireTOF, (_expectedTargetPos distance _heli) * SCALE_METERS_KM] call fza_fnc_linearInterp) # 1 + CBA_missionTime);
    _heli setvariable ["fza_ah64_tofCountDown", _currentTof];
};

if (isNil "_target" || !(_target isKindOf "AllVehicles")) then {
    _timeToActive = 999;
    _target = objNull;
};

if (([_heli, [getpos _target, speed _target, _target]] call fza_hellfire_fnc_limaLoblCheck)#1) then {
    _attackProfile = "hellfire";
    _isActive = true;
    _targetVel = velocity _target;
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

_launchParams set [0, objNull];
_launchParams set [3, _attackProfile];
_projectile setMissileTarget objNull;
[_heli] call fza_fcr_fnc_cycleNTS;