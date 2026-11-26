/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_swapFlares

Description:
    Fits the countermeasures for the mission equipment, full: the US chaff, or the UK
    HIDAS left and right flare pods and chaff. Run where the aircraft is local.

Parameters:
    _heli  - The helicopter
    _phase - The msn_equip_british phase

Returns:
    Nothing

Examples:
    [_heli, _heli animationPhase "msn_equip_british"] call fza_ase_fnc_swapFlares

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_phase"];

{_heli removeWeaponTurret [_x, [-1]];} forEach ["fza_CMChaffLauncher", "fza_CMFlareLauncher", "fza_CMFlareLauncherL", "fza_CMFlareLauncherR", "fza_CMChaffLauncherL"];
{_heli removeMagazinesTurret [_x, [-1]];} forEach ["fza_chaff_30_mag", "fza_flare_30_mag", "fza_flare_32L_mag", "fza_flare_32R_mag", "fza_chaff_64_mag"];

private _fit = [
    [["fza_CMChaffLauncher", "fza_chaff_30_mag"]],
    [["fza_CMFlareLauncherL", "fza_flare_32L_mag"], ["fza_CMFlareLauncherR", "fza_flare_32R_mag"], ["fza_CMChaffLauncherL", "fza_chaff_64_mag"]]
] select (_phase > 0.5);
{
    _x params ["_weapon", "_magazine"];
    _heli addMagazineTurret [_magazine, [-1]];
    _heli addWeaponTurret [_weapon, [-1]];
} forEach _fit;
