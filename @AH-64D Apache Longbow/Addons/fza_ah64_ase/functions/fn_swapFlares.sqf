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
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_phase"];

_heli removeWeaponTurret ["fza_CMFlareLauncher", [-1]];
_heli removeMagazineTurret ["60Rnd_CMFlareMagazine",[-1]];

if (_phase > 0.5) then {
    _heli addWeaponTurret ["fza_CMFlareLauncher", [-1]];
    _heli addMagazineTurret ["60Rnd_CMFlareMagazine",[-1]];
};