/* ----------------------------------------------------------------------------
Function: fza_fnc_HellfireGetAttackProfile

Description:
	grabs the ace name for the current attack mode.

Parameters:
    _heli - the helicopter

Returns:
	Nothing

Examples:
    [_heli] call fza_fnc_HellfireGetAttackProfile

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _trajectory = _heli getvariable "fza_ah64_hellfireTrajectory";
Private _result = false;

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