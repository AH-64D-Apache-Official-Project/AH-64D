/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_smoothAverageGet

Description:

Parameters:

Returns:
 
Examples:
    ...

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_average"];

_average params ["_arr"];
private _numSamples = 0;
private _sum = 0;
{
    if isNil "_x" then { continue; };
    _numSamples = _numSamples + 1;
    _sum = _sum + _x;
} forEach _arr;

_sum / _numSamples;