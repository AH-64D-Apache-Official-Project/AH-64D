/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_aimInputBlocked

Description:
    Whether the aim input is taken by something other than the TADS: heads up,
    free look turning the head or the cockpit cursor while it is detached; the
    radial menu while open. Free look does not apply heads down.

Parameters:
    None

Returns:
    True when the aim input should not slew the TADS

Examples:
    --- Code
    if (call fza_ihadss_fnc_aimInputBlocked) then {_rate = 0};
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
(freeLook && {cameraView != "GUNNER"})
    || {uiNamespace getVariable ["fza_radialOpen", false]}
    || {cameraView == "INTERNAL" && {((missionNamespace getVariable ["hct_interaction_trackIR_interaction_cursor", false]) && {!fza_ah64_tadsIgnoreHatchetCursor}) || {uiNamespace getVariable ["hct_interaction_mouseBlocker", false]}}}
