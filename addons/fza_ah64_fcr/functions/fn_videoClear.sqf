/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_videoClear

Description:
    Commands a hard clear of the RMAP and/or TPM video. The clear is a
    replicated counter, so every crew station's display restarts its picture,
    not only the machine that ran the command.

Parameters:
    _heli - The helicopter
    _rmap - (optional, default true) clear the RMAP video
    _tpm  - (optional, default false) clear the TPM video and obstacles

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", ["_rmap", true], ["_tpm", false]];

if (_rmap) then {
    _heli setVariable ["fza_ah64_fcrRMAPClearEpoch", (_heli getVariable ["fza_ah64_fcrRMAPClearEpoch", 0]) + 1, true];
};
if (_tpm) then {
    _heli setVariable ["fza_ah64_fcrTPMClearEpoch", (_heli getVariable ["fza_ah64_fcrTPMClearEpoch", 0]) + 1, true];
};
