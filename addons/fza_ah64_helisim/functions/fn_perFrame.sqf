/* ----------------------------------------------------------------------------
Function: fza_ah64_helisim_fnc_perFrame

Description:
    Per-frame tick. The schedule lives in Core; pack-specific work goes here.

Parameters:
    _heli - The helicopter [Object]

Returns:
    Nothing
---------------------------------------------------------------------------- */
params ["_heli"];

[_heli] call bmkhs_fnc_coreUpdate;
[_heli] call fza_ah64_helisim_fnc_perfData;
