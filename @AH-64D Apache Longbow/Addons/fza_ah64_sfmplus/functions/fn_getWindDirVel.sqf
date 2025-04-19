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
#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_heli"];

private _windDir = round((windDir + 180) mod 360);
private _windVel = round((vectorMagnitude wind) * MPS_TO_KNOTS);

[_windDir,_windVel];