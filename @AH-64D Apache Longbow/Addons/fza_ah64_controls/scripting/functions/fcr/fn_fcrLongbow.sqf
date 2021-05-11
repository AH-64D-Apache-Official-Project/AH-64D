/* ----------------------------------------------------------------------------
Function: fza_fnc_fcrLongbow
Description:
    Fire control Radar script that takes target from sens radar and adds it to 
    fza_ah64_targetlist & fza_ah64_fcrlist
Parameters:
Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_fcrLongbow;
Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
if (!(isNil "fza_ah64_nofcr")) exitwith {};
_heli = vehicle player;
if !((vehicle player) animationphase "plt_apu" > 0.5 || (isEngineOn _heli)) exitwith {};

#define AGMODE_GND 0
#define AGMODE_AIR 1
_datalinkarray = [];

if (isVehicleRadarOn _heli && (_heli animationPhase "fcr_enable" == 1) && _heli getHit "radar" < 0.8) then {
	_datalinkarray = (listRemoteTargets playerSide) apply {_x # 0};
	{
		_distOffAxis = abs ([[_heli, (getposatl _heli select 0), (getposatl _heli select 1), (getposatl _x select 0), (getposatl _x select 1)] call fza_fnc_relativeDirection] call CBA_fnc_simplifyAngle180);
		if (_x == _heli || _x isKindOf "man" || _x isKindOf "StaticCannon" || laserTarget _heli == _x) then {
			_dataLinkArray = _dataLinkArray - [_x];
		};
		if !(alive _x) then {
			_dataLinkArray = _dataLinkArray - [_x];
		};
		if ((_heli getVariable "fza_ah64_agmode" == AGMODE_GND) && (_distOffAxis > 45)) then {
			_dataLinkArray = _dataLinkArray - [_x];
		};				
		if (_heli getVariable "fza_ah64_agmode" == AGMODE_AIR && !(_x isKindOf "air")) then {
			_dataLinkArray = _dataLinkArray - [_x];
		};
		{
			_lastPos = _heli modelToWorldWorld [0,2.1,2.2];
			_p2 = aimPos _x;
			_dir = _lastPos vectorFromTo _p2;
			_totalDist = _lastPos distance _p2;
			_clear = true;
			for "_i" from 3000 to _totalDist step 3000 do {
				_NextPos = (_dir vectorMultiply _i) vectorAdd _lastPos;
				//check from _lastPos to _NextPos;
				_ins = lineIntersectsSurfaces [_lastPos, _nextPos, _heli, _x];
				if (_ins isNotEqualTo []) then {
					_clear = false;
					_dataLinkArray = _dataLinkArray - [_x]; break;
				};
				_lastPos = _NextPos;
			};
			if (_clear) then {
				_ins = lineIntersectsSurfaces [_lastPos , _p2, _heli, _x];
				if (_ins isNotEqualTo []) then {
					_dataLinkArray = _dataLinkArray - [_x];
				};
			}
		};
		sleep 0.30;
	}   foreach _dataLinkArray;
	{
		if !(_x in fza_ah64_targetlist) then{
			fza_ah64_targetlist = fza_ah64_targetlist + [_x];
		};
	} foreach _dataLinkArray;
};
fza_ah64_fcrlist = _dataLinkArray;

[_heli] call fza_fnc_targetingVariable;


/*

		if ([_heli, "GEOM", _x] checkVisibility [_heli modelToWorldWorld [0,2.1,2.2], aimPos _x] == 0) then {
			_dataLinkArray = _dataLinkArray - [_x];