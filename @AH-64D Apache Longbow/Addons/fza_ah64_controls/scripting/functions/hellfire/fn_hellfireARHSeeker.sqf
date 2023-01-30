/* ----------------------------------------------------------------------------
Function: fza_fnc_hellfireARHSeeker

Description:
    The Seeker Head for Radar Missile

Parameters:
	_args - contains all of the main following paramaters
    _firedEH - the intirety of the fired eh event handler output
    _stateParams - contains an array of custom hellfire varaibels [Target object, Target position, Target type, Lima Lobl StartLobl]
    _shooter - the Apache 
    _projectile - the projectile object
	_seekerAngle - cfg seeker max angle
	_seekerMaxRange - cfg seeker max range
	_targetObj - Target object
	_targetPos - Target last position
	_targetType - Target type

Returns:
	Nothing

Examples:
	Nothing

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["", "_args", "_seekerStateParams"];
_args params ["_firedEH", "", "", "_seekerParams", ""];
_firedEH params ["_shooter","","","","","","_projectile"];
_seekerParams params ["_seekerAngle", "", "_seekerMaxRange"];
_seekerStateParams params ["_targetObj", "_targetPos", "_targetType","","_losCounter"];


private _heli				= vehicle _shooter;
private _returnTargetPos  	= _TargetPos;
private _selectedTarget		= objNull;

private _seekerConfig = configFile >> "CfgAmmo" >> "fza_agm114l" >> "ace_missileguidance";
private _seekerAngle = getNumber (_seekerConfig >> "seekerAngle");
if !([_projectile, _targetPos, _seekerAngle*0.75] call fza_fnc_hellfireCheckSeekerAngle) exitWith {
	_targetPos
};

if !(isNull _targetObj) then {
	private _loblCheckLima = [_projectile, [getpos _targetObj, "", speed _targetObj, _targetObj], true] call fza_fnc_hellfireLimaLoblCheck;
	_seekerStateParams set [4, (_losCounter + 1) % 10];
	if (_loblCheckLima # 1 || !(_losCounter % 10 == 0)) then {
		_selectedTarget = _targetObj;
		if (_loblCheckLima # 1) then {
			_seekerStateParams set [4, 1];
		};
	} else {
		_selectedTarget = objNull;
	};
} else {
	_seekerStateParams set [4, 1];
	private _newScanTargets  = nearestObjects [_TargetPos, ["land","air","ship"], 500];
	private _validTargets 	 = _newScanTargets apply {
		if ((([_projectile, [getpos _x, "", speed _x, _x], true] call fza_fnc_hellfireLimaLoblCheck) # 1)) then {
			_x
		};
	};

	private _primaryTargets = _validTargets select {
		private _targTypeCompare = _x call BIS_fnc_objectType;
		(_targetType isEqualTo _targTypeCompare)
	};
	private _secondaryTargets = _validTargets select {
		private _targTypeCompare = _x call BIS_fnc_objectType;
		!(_targetType isEqualTo _targTypeCompare)
	};
	if (_primaryTargets isNotEqualTo []) then {
		_selectedTarget = [_primaryTargets, _TargetPos] call BIS_fnc_nearestPosition;
	} else {
		if (_secondaryTargets isNotEqualTo []) then {
			_selectedTarget = [_secondaryTargets, _TargetPos] call BIS_fnc_nearestPosition;
		};
	};
};

if !(isNull _selectedTarget) then {
	private _centerOfObject = getCenterOfMass _selectedTarget;
	private _aimPosTarget = _selectedTarget modelToWorldWorld _centerOfObject;

	private _projectileVelocity = velocity _projectile;
	private _projectileSpeed = vectorMagnitude _projectileVelocity; // this gives a precise impact time versus using speed _projectile. Dont change
	private _timeUntilImpact = (_aimPosTarget distance _projectile) / _projectileSpeed;
	_returnTargetPos = _aimPosTarget vectorAdd (velocity _selectedTarget vectorMultiply _timeUntilImpact);
	_seekerStateParams set [0, _selectedTarget];
	_seekerStateParams set [1, _returnTargetPos];
} else {
	_seekerStateParams set [0, objNull];
};

_returnTargetPos;