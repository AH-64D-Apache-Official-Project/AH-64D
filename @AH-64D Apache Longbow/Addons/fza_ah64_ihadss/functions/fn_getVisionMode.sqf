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

private _Visionmode = (_heli currentVisionMode [0]) # 0;
private _a3ti_vis   = call A3TI_fnc_getA3TIVision;
if ((_heli getVariable "fza_ah64_tadsSelectedSensor") == "DVO") then {_Visionmode = 3;};
if !(isNil "_a3ti_vis") then {_Visionmode = 1;};
_Visionmode;