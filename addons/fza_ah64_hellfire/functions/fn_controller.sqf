/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_controller
Description:
    Runs per-frame Hellfire systems that depend on current aircraft state.
Parameters:
    _heli - The helicopter
Returns:
    Nothing
Author: Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

[_heli] call fza_hellfire_fnc_syncAceMissileParams;
[_heli] call fza_hellfire_fnc_tadsRfHandoffUpdate;
