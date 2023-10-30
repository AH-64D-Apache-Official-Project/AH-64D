/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_controller


Description:
    Handles all ASE systems on the aircraft

Parameters:
    heli: Object - Vehicle the event handler is assigned to

Returns:
    Nothing

Examples:
    [_heli] call fza_ase_fnc_controller

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

private _deltaTime = ["ase_deltaTime"] call BIS_fnc_deltaTime;

[_heli] call fza_ase_fnc_rlwr;
[_heli] call fza_ase_fnc_audioController;

[_heli, _deltaTime] call fza_ase_fnc_irJam;
