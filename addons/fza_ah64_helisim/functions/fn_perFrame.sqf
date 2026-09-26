/* ----------------------------------------------------------------------------
Function: fza_ah64_helisim_fnc_perFrame

Description:
    Per-frame tick. The schedule lives in Core - every call it held was Core work on
    Core state, duplicated identically in each pack. What stays here is the seam:
    somewhere for this aircraft's own per-frame work to go, if it ever needs any.

Parameters:
    _heli - The helicopter [Object]

Returns:
    Nothing
---------------------------------------------------------------------------- */
params ["_heli"];

[_heli] call bmkhs_fnc_coreUpdate;
