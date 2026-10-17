/* ----------------------------------------------------------------------------
Function: fza_ihadss_fnc_getVisionMode

Description:
    returns the vision mode of tads

Parameters:
    _heli - The apache

Returns:
    0: DTV
    1: A3ti
    2: FLIR
    3: DVO

Examples:
    --- Code
    _return = [_heli] call fza_ihadss_fnc_getVisionMode
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

// From the selected sensor: the turret's own vision mode only follows it while looking through the sight
private _sensor   = _heli getVariable ["fza_ah64_tadsSelectedSensor", "FLIR"];
private _a3ti_vis = call A3TI_fnc_getA3TIVision;
switch (true) do {
    case (_sensor == "DVO"):    {3};
    case (_sensor == "DTV"):    {0};
    case (!isNil "_a3ti_vis"): {1};
    default                     {2};
};
