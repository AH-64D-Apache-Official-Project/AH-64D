/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_getWindDirVel

Description:
    Format - Str
    Gets wind information and packages it into correct wind Dir & velocity format
    for the Tsd & Perf Page

Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    [Dir, Speed]

Examples:
    ...

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _windDir = fza_ah64_sfmPlusWindDirection;
private _windVel = fza_ah64_sfmPlusWindSpeed;

[_windDir,_windVel];