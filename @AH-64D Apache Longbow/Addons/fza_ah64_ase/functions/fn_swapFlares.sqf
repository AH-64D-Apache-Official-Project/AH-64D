/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_swapFlares

Description:
    Adds and removes the flares

Parameters:
    heli: Object - Vehicle the event handler is assigned to

Returns:
    Nothing

Examples:
    [_heli] call fza_ase_fnc_swapFlares

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli", "_phase"];

if (_phase > 0.5) then {
    vehicle player addWeaponTurret ["fza_CMFlareLauncher", [-1]];
    vehicle player addMagazineTurret ["60Rnd_CMFlareMagazine",[-1]];
} else {
    vehicle player removeWeaponTurret ["fza_CMFlareLauncher", [-1]];
    vehicle player removeMagazineTurret ["60Rnd_CMFlareMagazine",[-1]];
};