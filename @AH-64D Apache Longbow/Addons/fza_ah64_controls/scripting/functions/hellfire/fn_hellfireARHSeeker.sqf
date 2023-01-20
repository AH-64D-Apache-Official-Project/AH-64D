/* ----------------------------------------------------------------------------
Function: fza_fnc_hellfireARHSeeker

Description:
    The Seeker Head for Radar Missile

Parameters:
    _heli - The helicopter to modify

Returns:
	Nothing

Examples:
	Nothing

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["", "_args", "_seekerStateParams"];
_args params ["_firedEH", "_launchParams", "", "_seekerParams", "_stateParams"];
_firedEH params ["_shooter","","","","","","_projectile"];
_seekerParams params ["_seekerAngle", "", "_seekerMaxRange"];
_seekerStateParams params ["_TargetObj", "_TargetPos", "_TargetType","_LaunchLobl"];


private _heli 				= vehicle _shooter;
private _returnTargetPos  	= _TargetPos;
private _SelectedTarget		= objNull;
private _LOSCounterVAR		= "fza_ah64_" + str _projectile + "_Los_Lost_FrameCounter";
private _LosLostCounter 	= _heli getVariable [_LOSCounterVAR, 1];

if !(isNull _TargetObj) then {
	private _LoblCheckLima = [_projectile, [getpos _TargetObj, "", speed _TargetObj, _TargetObj], true] call fza_fnc_hellfireLimaLoblCheck;
	_heli setVariable [_LOSCounterVAR, (_LosLostCounter + 1) % 10];
	if (_LoblCheckLima # 1 == true || !(_LosLostCounter % 10 == 0)) then {
		_SelectedTarget = _TargetObj;
		if (_LoblCheckLima # 1 == true) then {
			_heli setVariable [_LOSCounterVAR, 1];
		};
	} else {
		_SelectedTarget = objNull;
	};
} else {
	_heli setVariable [_LOSCounterVAR, 1];
	if (_projectile distance _TargetPos < 2000) then {

		private _newScanTargets  = nearestObjects [_TargetPos, ["land","air","ship"], 500];
        private _validTargets 	 = _newScanTargets apply {
            if ((([_projectile, [getpos _x, "", speed _x, _x], true] call fza_fnc_hellfireLimaLoblCheck) # 1) == true) then {
                _x
            };
        };

		private _Primarytargets = _validTargets select {
			private _targTypeCompair = _x call BIS_fnc_objectType;
			(_targetType isEqualTo _targTypeCompair)
		};
		private _secondarytargets = _validTargets select {
			private _targTypeCompair = _x call BIS_fnc_objectType;
			!(_targetType isEqualTo _targTypeCompair)
		};
		If (_Primarytargets isNotEqualTo []) then {
			_SelectedTarget = [_Primarytargets, _TargetPos] call BIS_fnc_nearestPosition;
		} else {
			If (_secondarytargets isNotEqualTo []) then {
				_SelectedTarget = [_secondarytargets, _TargetPos] call BIS_fnc_nearestPosition;
			};
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


#ifdef __A3_DEBUG__
hintSilent format ["TargetObj = %1,
				\nTargetPos = %2,
				\nValidtarget = %3,
				\nPrimaryTargets = %4,
				\nSecondarytargets = %5,
				\nFinalTarget = %6,
				\nreturnTargetPos = %7", _TargetObj, _TargetPos, _validTargets, _Primarytargets, _secondarytargets, _SelectedTarget, _returnTargetPos];
#endif

_returnTargetPos;