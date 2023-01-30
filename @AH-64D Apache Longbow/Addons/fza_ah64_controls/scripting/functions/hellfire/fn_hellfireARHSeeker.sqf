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

if !(isNull _TargetObj) then {
	private _loblCheckLima = [_projectile, [getpos _TargetObj, "", speed _TargetObj, _TargetObj], true] call fza_fnc_hellfireLimaLoblCheck;
	_seekerStateParams set [4, (_LosLostCounter + 1) % 10];
	if (_loblCheckLima # 1 || !(_LosLostCounter % 10 == 0)) then {
		_SelectedTarget = _TargetObj;
		if (_loblCheckLima # 1) then {
			_seekerStateParams set [4, 1];
		};
	} else {
		_SelectedTarget = objNull;
	};
} else {
	_seekerStateParams set [4, 1];
	private _newScanTargets  = nearestObjects [_TargetPos, ["land","air","ship"], 500];
	private _validTargets 	 = _newScanTargets apply {
		if ((([_projectile, [getpos _x, "", speed _x, _x], true] call fza_fnc_hellfireLimaLoblCheck) # 1)) then {
			_x
		};
	};

	private _Primarytargets = _validTargets select {
		private _targTypeCompare = _x call BIS_fnc_objectType;
		(_targetType isEqualTo _targTypeCompare)
	};
	private _secondarytargets = _validTargets select {
		private _targTypeCompare = _x call BIS_fnc_objectType;
		!(_targetType isEqualTo _targTypeCompare)
	};
	if (_Primarytargets isNotEqualTo []) then {
		_SelectedTarget = [_Primarytargets, _TargetPos] call BIS_fnc_nearestPosition;
	} else {
		If (_secondarytargets isNotEqualTo []) then {
			_SelectedTarget = [_secondarytargets, _TargetPos] call BIS_fnc_nearestPosition;
		};
	};
};

if !(isNull _SelectedTarget) then {
	//private _aimPosTarget = aimpos _SelectedTarget;
	private _centerOfObject = getCenterOfMass _SelectedTarget;
	private _aimPosTarget = _SelectedTarget modelToWorldWorld _centerOfObject;

	private _projectileVelocity = velocity _projectile;
	private _projectileSpeed = vectorMagnitude _projectileVelocity; // this gives a precise impact time versus using speed _projectile. Dont change
	private _timeUntilImpact = (_aimPosTarget distance _projectile) / _projectileSpeed;
	systemchat str _timeUntilImpact;
	_returnTargetPos = _aimPosTarget vectorAdd (velocity _SelectedTarget vectorMultiply _timeUntilImpact);
	_seekerStateParams set [0, _SelectedTarget];
	_seekerStateParams set [1, _returnTargetPos];
} else {
	_seekerStateParams set [0, objNull];
};



hintSilent format ["TargetObj = %1,
				\nTargetPos = %2,
				\nFinalTarget = %6,
				\nreturnTargetPos = %7", _TargetObj, _TargetPos, _SelectedTarget, _returnTargetPos];


_returnTargetPos;