/* ----------------------------------------------------------------------------
Function: fza_fnc_targetingSetAcquisitionSource

Description:
    Sets the player's seat's aquisition source to the source specified
    - 0 is FCR
    - 1 is HMD
    - 2 is TADS
    - 3 is FXD

Parameters:
    _heli - The helicopter to act on
    _acq - The acquisition source ID

Returns:
	Nothing

Examples:
	--- Code
    [_heli, 0] call fza_fnc_targetingSetAcquisitionSource
    // The acquisition source is now 0 (FCR).
	---

Author:
	mattysmith22
---------------------------------------------------------------------------- */
params ["_heli", "_acq"];

if (player == driver _heli) then {
    _heli setVariable ["fza_ah64_acq_plt", _acq, true];
};
if (player == gunner _heli) then {
    _heli setVariable ["fza_ah64_acq_cpg", _acq, true];
}