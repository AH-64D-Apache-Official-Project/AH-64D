/* ----------------------------------------------------------------------------
Function: bmkhs_sfmplus_fnc_isNAN

Description:
    Returns true or false if a value is not a number

Parameters:
    _val - The value that needs to be checked.

Returns:
    true or false

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_val"];

if (_val isEqualType "SCALAR" || _val isEqualType "NAN") exitwith { true };
false;