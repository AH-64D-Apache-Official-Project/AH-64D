/* ----------------------------------------------------------------------------
Function: fza_fnc_hellfireARHFired

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
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_firedEH", "", "", "", "_stateParams"];
_firedEH params ["_shooter","","","","","","_projectile"];
_stateParams params ["", "_seekerStateParams"];
_targetLaunchParams params ["", "_targetpos", "_launchPos"];


private _heli           = vehicle _shooter;
private _targinfo       = _heli getVariable "fza_ah64_fcrNts";
private _targObj        = _targinfo #0;
private _targPos        = _targinfo #1;
private _targetType     = _targobj call BIS_fnc_objectType;
private _loblCheckLima  = [_heli, [getpos _targObj, "", speed _targObj, _targObj]] call fza_fnc_hellfireLimaLoblCheck;

if (!(isNull _targObj) && _loblCheckLima #1) then {
	_targPos = getposasl _targObj;
} else {
	_targObj = Objnull;
};

//Cycle Radar targets
[_heli] call fza_fnc_targetingsensorCycle;

//Dir trajectory at close range
private _attackProfile = "hellfire_hi";
if (_loblCheckLima #1) then {
	_attackProfile = "hellfire";
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