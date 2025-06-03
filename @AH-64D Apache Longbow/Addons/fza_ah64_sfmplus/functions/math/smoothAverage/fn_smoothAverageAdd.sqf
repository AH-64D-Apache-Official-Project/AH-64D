/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_smoothAverageAdd

Description:

Parameters:

Returns:
 
Examples:
    ...

Author:
    mattysmith22
---------------------------------------------------------------------------- */
params ["_average", "_inp"];

_average params ["_arr", "_nextIdx"];
_arr set [_nextIdx, _inp];
_nextIdx = (_nextIdx + 1) % count _arr;
_average set [1, _nextIdx];