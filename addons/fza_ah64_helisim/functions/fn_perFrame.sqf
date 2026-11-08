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

[_heli] call fza_ah64_helisim_fnc_cyclicFade;
[_heli] call bmkhs_fnc_coreUpdate;
//After Core, so it reads the bmkhs_deltaTime published this frame.
[_heli] call fza_suspension_fnc_suspensionUpdate;
[_heli] call fza_ah64_helisim_fnc_perfData;
