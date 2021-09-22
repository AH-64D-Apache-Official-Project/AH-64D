/*----------------------------------------------------------------------------
Function: fza_fnc_fcrLongbow

Description:
    Fire control Radar script that takes target from sens radar and adds it to 
    fza_ah64_targetlist & fza_ah64_fcrlist

Parameters:
	_heli - the heli to act upon

Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_fcrLongbow;

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];
if (!(isNil "fza_ah64_nofcr")) exitwith {};

if !(_heli animationphase "plt_apu" > 0.5 || (isEngineOn _heli)) exitwith {};

#define AGMODE_GND 0
#define AGMODE_AIR 1

private _datalinkarray = [];

if (isVehicleRadarOn _heli && (_heli animationPhase "fcr_enable" == 1) && _heli getHit "radar" < 0.8) then {
	_datalinkarray = [];
	{
		private _target = _x # 0;

		private _distOffAxis = abs ([[_heli, (getposatl _heli select 0), (getposatl _heli select 1), (getposatl _target select 0), (getposatl _target select 1)] call fza_fnc_relativeDirection] call CBA_fnc_simplifyAngle180);
		if (_target == _heli || _target isKindOf "man" || _target isKindOf "StaticCannon" || laserTarget _heli == _target) then {
			continue;
		};
		if !(alive _target) then {
			continue;
		};
		if ((_heli getVariable "fza_ah64_agmode" == AGMODE_GND) && (_distOffAxis > 45) && ((_heli distance2D _target) > 8000)) then {
			continue;
		};				
		if (_heli getVariable "fza_ah64_agmode" == AGMODE_AIR && !(_target isKindOf "air") && ((_heli distance2D _target) > 8000)) then {
			continue;
		};

		//LOS check Beg
		if (fza_ah64_ExperimentalFCR) then {
			_lastPos = _heli modelToWorldWorld [0,2.1,2.2];
			_p2 = aimPos _target;
			_dir = _lastPos vectorFromTo _p2;
			_totalDist = _lastPos distance _p2;
			_clear = true;
			for "_i" from 4000 to _totalDist step 4000 do {
				_NextPos = (_dir vectorMultiply _i) vectorAdd _lastPos;
				//check from _lastPos to _NextPos;
				_ins = lineIntersectsSurfaces [_lastPos, _nextPos, _heli, _target, true, 1, "GEOM", "FIRE"];
				if (_ins isNotEqualTo []) then {
					_clear = false;
					break;
				};
				_lastPos = _NextPos;
			};
			if (_clear) then {
				_ins = lineIntersectsSurfaces [_lastPos , _p2, _heli, _target, true, 1, "GEOM", "FIRE"];
				if (_ins isNotEqualTo []) then {
					continue
				};
			} else {
				continue
			};
		};
		//LOS check end

		_dataLinkArray pushBack _Target;

		if (!(_target in fza_ah64_targetlist)) then {
			fza_ah64_targetlist = fza_ah64_targetlist + [_target];
		};
		sleep 0.02;
	}   foreach listRemoteTargets playerSide;
};

fza_ah64_fcrlist = _dataLinkArray;
[_heli] call fza_fnc_targetingVariable;