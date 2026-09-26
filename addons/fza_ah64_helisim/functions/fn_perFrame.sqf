/* ----------------------------------------------------------------------------
Function: fza_ah64_helisim_fnc_perFrame

Description:
    Per-frame tick. The schedule lives in Core; this is where pack-specific
    per-frame work goes.

Parameters:
    _heli - The helicopter [Object]

Returns:
    Nothing
---------------------------------------------------------------------------- */
params ["_heli"];

[_heli] call bmkhs_fnc_coreUpdate;
