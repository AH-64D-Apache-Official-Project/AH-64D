/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_chaff

Description:
    Handles the launching of chaff

Parameters:
    heli: Object - Vehicle the event handler is assigned to

Returns:
    Nothing

Examples:
    [_heli] call fza_ase_fnc_chaff

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

if (_heli getVariable "fza_ah64_ase_chaffState" == "safe") exitWith {};

[vehicle player, "fza_CMChaffLauncher", [-1]] call BIS_fnc_fire;