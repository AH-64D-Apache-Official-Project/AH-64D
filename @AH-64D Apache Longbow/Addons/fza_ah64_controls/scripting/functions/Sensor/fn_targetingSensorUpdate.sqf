/*----------------------------------------------------------------------------
Function: fza_fnc_targetingSensorUpdate

Description:
    Fire control Radar script that takes target from sens radar and adds it to 
    fza_ah64_targetlist & fza_ah64_fcrlist

Parameters:
	_heli - the heli to act upon

Returns:
    Nothing
    
Examples:
    [_heli] spawn fza_fnc_targetingSensorUpdate;

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];
if (!(isNil "fza_ah64_nofcr")) exitwith {};
if !(_heli animationphase "plt_apu" > 0.5 || (isEngineOn _heli)) exitwith {};

#define AGMODE_GND 0
#define AGMODE_AIR 1

private _fcrTargets = [];
private _detectedActiveRadars = [];

_fcrTargets = [];
{
	_x params ["_target", "_type", "_relationship", "_sensor"];

	private _distOffAxis = abs ([[_heli, (getposatl _heli select 0), (getposatl _heli select 1), (getposatl _target select 0), (getposatl _target select 1)] call fza_fnc_relativeDirection] call CBA_fnc_simplifyAngle180);
	if (_relationship == "destroyed") then {
		continue;
	};
	if (("passiveradar" in _sensor || "laser" in _sensor) && !(_Target in _detectedActiveRadars)) then {
		_detectedActiveRadars pushBack _Target;
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

	_fcrTargets pushBack _Target;

	if !(_target in fza_ah64_targetlist) then {
		fza_ah64_targetlist pushBack _Target;
	};
	sleep 0.05;
}   foreach getSensorTargets _heli;

fza_ah64_fcrlist = _fcrTargets;
fza_ah64_AseRWR = _detectedActiveRadars;
[_heli] call fza_fnc_targetingVariable;