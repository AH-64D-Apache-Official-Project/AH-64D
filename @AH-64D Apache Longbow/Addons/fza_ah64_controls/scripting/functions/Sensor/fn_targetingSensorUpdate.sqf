/*----------------------------------------------------------------------------
Function: fza_fnc_targetingSensorUpdate

Description:
    Fire control Radar script that takes target from sens radar and adds it to

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
if !(_heli getVariable "fza_ah64_apu" || (isEngineOn _heli)) exitwith {};

private _detectedActiveRadars = [];
{
	_x params ["_target", "_type", "_relationship", "_sensor"];

	private _distOffAxis = abs ([[_heli, (getposatl _heli select 0), (getposatl _heli select 1), (getposatl _target select 0), (getposatl _target select 1)] call fza_fnc_relativeDirection] call CBA_fnc_simplifyAngle180);
	if (_relationship == "destroyed") then {
		continue;
	};
	if (("passiveradar" in _sensor || "laser" in _sensor)) then {
		_detectedActiveRadars pushBack _Target;
	};
	if !("activeradar" in _sensor && _heli getHit "radar" < 0.9) then {
		continue;
	};
	
	if (_distOffAxis > 45) then {
		continue;
	};

	sleep 0.05;
} foreach getSensorTargets _heli;

fza_ah64_AseRWR = _detectedActiveRadars;