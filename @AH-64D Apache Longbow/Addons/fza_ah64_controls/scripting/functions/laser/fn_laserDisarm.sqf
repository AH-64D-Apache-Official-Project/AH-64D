/* ----------------------------------------------------------------------------
Function: fza_fnc_laserDisarm

Description:
    Disarms the apache's LRFD, from either seat.

Parameters:
    _heli - The helicopter to act upon

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_fnc_laserDisarm
    ---

Author:
    Unknown, mattysmith22
---------------------------------------------------------------------------- */
params ["_heli"];

if !(isNull laserTarget _heli) then {
    [_heli, "Laserdesignator_mounted", [0]] call BIS_fnc_fire;
}