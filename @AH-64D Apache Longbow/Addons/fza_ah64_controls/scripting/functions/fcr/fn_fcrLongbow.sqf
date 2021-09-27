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
private _activeradar = [];

if ((_heli animationPhase "fcr_enable" == 1) && _heli getHit "radar" < 0.8) then {
	_datalinkarray = [];
	{
		private _target = _x # 0;
		private _type = _x # 1;
		private _relationship = _x # 2;
		private _sensor = _x # 3;

		private _distOffAxis = abs ([[_heli, (getposatl _heli select 0), (getposatl _heli select 1), (getposatl _target select 0), (getposatl _target select 1)] call fza_fnc_relativeDirection] call CBA_fnc_simplifyAngle180);
		if (_relationship == "destroyed") then {
			continue;
		};
		if (("passiveradar" in _sensor && _type == "ground") && !(_Target in _activeradar)) then {
			_activeradar pushBack _Target;
		};
		if !("activeradar" in _sensor) then {
			continue;
		};
		
		if (_heli getVariable "fza_ah64_agmode" == AGMODE_GND && (_distOffAxis > 45)) then {
			continue;
		};				
		if (_heli getVariable "fza_ah64_agmode" == AGMODE_AIR && !(_type == "air")) then {
			continue;
		};

		_dataLinkArray pushBack _Target;

		if !(_target in fza_ah64_targetlist) then {
			fza_ah64_targetlist pushBack _Target;
		};
	}   foreach getSensorTargets _heli;
};

fza_ah64_fcrlist = _dataLinkArray;
fza_ah64_AseRWR = _activeradar;
[_heli] call fza_fnc_targetingVariable;