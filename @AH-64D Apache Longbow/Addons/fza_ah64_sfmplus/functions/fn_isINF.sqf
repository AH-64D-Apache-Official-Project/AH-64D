/* ----------------------------------------------------------------------------
Function: bmkhs_sfmplus_fnc_isINF

Description:
    Returns true or false if a value is infinite

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

if (not finite _val) exitwith { true };
false;