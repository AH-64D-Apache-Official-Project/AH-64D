/* ----------------------------------------------------------------------------
Function: fza_laser_fnc_arm

Description:
    Arms the apache's LRFD, from either seat. Must be run in scheduled environment (involve sleep)

Parameters:
    _heli - The helicopter to act upon

Returns:
    Nothing

Examples:
    --- Code
    [_heli] spawn fza_laser_fnc_arm
    ---

Author:
    Unknown, mattysmith22
---------------------------------------------------------------------------- */
params ["_heli"];

if (isNull laserTarget _heli) then {
    [_heli, "Laserdesignator_mounted", [0]] call BIS_fnc_fire;
};