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
fza_ah64_dataLinkArray = (listRemoteTargets playerSide) apply {_x # 0};

if (isVehicleRadarOn _heli && (_heli animationPhase "fcr_enable" == 1) && _heli getHit "radar" < 0.8) then {
	_datalinkarray = fza_ah64_dataLinkArray;
	{
		_distOffAxis = abs ([[_heli, (getposatl _heli select 0), (getposatl _heli select 1), (getposatl _x select 0), (getposatl _x select 1)] call fza_fnc_relativeDirection] call CBA_fnc_simplifyAngle180);
		if (_x == _heli || _x isKindOf "man" || _x isKindOf "StaticCannon") then {
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
		if ([_heli, "GEOM", _x] checkVisibility [_heli modelToWorld [0,2.1,14], aimPos _x] == 0) then {
			_dataLinkArray = _dataLinkArray - [_x];
		};
		sleep 0.20;
	}   foreach _dataLinkArray;
};
{
	if !(_x in fza_ah64_targetlist) then{
		fza_ah64_targetlist = fza_ah64_targetlist + _dataLinkArray;
	};
} foreach _dataLinkArray;
fza_ah64_fcrlist = _dataLinkArray;

[_heli] call fza_fnc_targetingVariable;

