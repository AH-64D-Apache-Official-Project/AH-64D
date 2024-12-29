/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_getVelocitiesSmoothAverage
Description:

Parameters:

Returns:

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_array", "_values"];

private _return = 0.0;

[_array, _values] call fza_sfmplus_fnc_smoothAverageAdd;
_return = [_array] call fza_sfmplus_fnc_smoothAverageGet;

_return;