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
    Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];
if (!(isNil "fza_ah64_nofcr")) exitwith {};

private _acBusOn = _heli getVariable "fza_systems_acBusOn";
private _dcBusOn = _heli getVariable "fza_systems_dcBusOn";

if !(_acBusOn && _dcBusOn) exitwith {};

private _detectedActiveRadars = [];
{
    _x params ["_target", "_type", "_relationship", "_sensor"];
    if (("passiveradar" in _sensor || "laser" in _sensor)) then {
        _detectedActiveRadars pushBack _Target;
    };

    sleep 0.05;
} foreach getSensorTargets _heli;

fza_ah64_AseRWR = _detectedActiveRadars;