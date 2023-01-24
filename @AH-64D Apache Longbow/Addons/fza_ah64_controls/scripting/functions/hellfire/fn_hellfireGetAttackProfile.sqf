/* ----------------------------------------------------------------------------
Function: fza_fnc_HellfireGetAttackProfile

Description:
	grabs the ace name for the current attack mode.

Parameters:
    _heli - the helicopter

Returns:
    grabs the apaches system trajectory setting & outputs the ace cfg Trajectory name

Examples:
    [_heli] call fza_fnc_HellfireGetAttackProfile

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _trajectory = _heli getVariable "fza_ah64_hellfireTrajectory";
private _result = false;

switch _trajectory do {
    case "DIR": {
        _result = "hellfire";
    };
    case "HI": {
        _result = "hellfire_hi";
    };
    case "LO": {
        _result = "hellfire_lo";
    };
};
_result;