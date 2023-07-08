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

private _windDir = round((windDir + 180) mod 360);
private _windVel = round((vectorMagnitude wind) * 1.94);

[_windDir,_windVel];