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
_args params ["_firedEH", "_launchParams ", "", "_seekerParams", ""];
_firedEH params ["_shooter","","","","","","_projectile"];
_seekerParams params ["_seekerAngle", "", "_seekerMaxRange"];
_seekerStateParams params ["_TargetObj", "_TargetPos", "_TargetType","_LaunchLobl"];

copyToClipboard str _this;

private _heli 				= vehicle _shooter;
private _distance       	= _heli distance _targObj;
private _armaRadarOn    	= isVehicleRadarOn _heli;
private _searchRadius 		= 200;
private _returnTargetPos  	= _TargetPos;

if (!(isNull _TargetObj) && [_projectile, _TargetObj, _seekerAngle] call ace_missileguidance_checkSeekerAngle && ([_heli, _TargetObj, false] call ace_missileguidance_fnc_checkLos || [_heli, _TargetObj, true] call ace_missileguidance_fnc_checkLos)) then {
	_SelectedTarget = _TargetObj;
} else {
	if (_projectile distance _TargetPos < 2500) then {

		private _newScanTargets  = nearestObjects [_TargetPos, ["allvehicles"],_searchRadius];
		
        private _validTargets = _newScanTargets apply {
			private _LOS1 				= [_heli, _TargetObj, false] call ace_missileguidance_fnc_checkLos;
			private _LOS2 				= [_heli, _TargetObj, true] call ace_missileguidance_fnc_checkLos;
			private _seekerangleCheck 	= [_projectile, _TargetObj, _seekerAngle] call ace_missileguidance_checkSeekerAngle;
            if (_seekerangleCheck && (_LOS1 || _LOS2)) then {
                _x
            } else {
                objNull
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
			_SelectedTarget = [_Primarytargets, _lastscantarget] call BIS_fnc_nearestPosition;
		} else {
			If (_secondarytargets isNotEqualTo []) then {
				_SelectedTarget = [_secondarytargets, _lastscantarget] call BIS_fnc_nearestPosition;
			};
		};

		If (_distance < 1000) then {
			_searchRadius = 500;
		};
	};
};

if !(isNull _SelectedTarget) then {
    private _centerOfObject = getCenterOfMass _SelectedTarget;
    private _targetAdjustedPos = _SelectedTarget modelToWorldWorld _centerOfObject;
	private _projectileVelocity = velocity _projectile;
	if (_projectileVelocity#2 < 0) then {
		private _projectileSpeed = vectorMagnitude _projectileVelocity; // this gives a precise impact time versus using speed _projectile. Dont change
		private _timeUntilImpact = (_targetAdjustedPos distance getposasl _projectile) / _projectileSpeed;
		_returnTargetPos = _returnTargetPos vectorAdd (velocity _SelectedTarget vectorMultiply _timeUntilImpact);
	};
	_launchParams set [0, _SelectedTarget];
	//_launchParams set [1, _returnTargetPos];
};

hintSilent format ["TargetObj = %1,
				\nTargetPos = %2,
				\nValidtarget = %3,
				\nFinalTarget = %4
				\nreturnTargetPos = %5", _TargetObj, _TargetPos, _validTargets, _SelectedTarget, _returnTargetPos];
_returnTargetPos;