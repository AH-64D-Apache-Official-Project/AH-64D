/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_restock

Description:
    Restocks the countermeasures to full for the mission equipment fitted: the US chaff,
    or the UK flares and chaff. Run where the aircraft is local.

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

[_heli, _heli animationPhase "msn_equip_british"] call fza_ase_fnc_swapFlares;
