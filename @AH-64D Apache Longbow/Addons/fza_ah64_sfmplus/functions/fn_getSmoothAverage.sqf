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

[_array, _values] call fza_sfmplus_fnc_smoothAverageAdd;
[_array] call fza_sfmplus_fnc_smoothAverageGet;