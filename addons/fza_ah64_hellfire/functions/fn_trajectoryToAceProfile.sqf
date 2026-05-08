/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_trajectoryToAceProfile
Description: Maps the hellfire trajectory mode to the ACE attack profile string.
Parameters: _heli - The helicopter
Returns: ACE attack profile string, or false if unrecognised
Author: Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _trajectory = _heli getVariable "fza_ah64_hellfireTrajectory";

switch (_trajectory) do {
    case "DIR": {"hellfire"};
    case "HI":  {"hellfire_hi"};
    case "LO":  {"hellfire_lo"};
    case "DBS": {"hellfire_hi"};
    default     {false};
};
