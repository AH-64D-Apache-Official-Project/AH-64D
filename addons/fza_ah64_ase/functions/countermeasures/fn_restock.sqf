/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_restock

Description:
    Restocks the countermeasures to full: the chaff, and the flares with the UK
    mission equipment. Run where the aircraft is local.

Parameters:
    _heli - The helicopter

Returns:
    Nothing

Examples:
    [_heli] remoteExec ["fza_ase_fnc_restock", _heli]

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

_heli removeWeaponTurret ["fza_CMChaffLauncher", [-1]];
_heli removeMagazinesTurret ["fza_chaff_30_mag", [-1]];
_heli addWeaponTurret ["fza_CMChaffLauncher", [-1]];
_heli addMagazineTurret ["fza_chaff_30_mag", [-1]];

[_heli, _heli animationPhase "msn_equip_british"] call fza_ase_fnc_swapFlares;
