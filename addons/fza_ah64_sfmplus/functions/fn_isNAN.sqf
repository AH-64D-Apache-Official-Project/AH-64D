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

// NaN is non-finite, so `not finite` catches both NaN and infinity.
if (not finite _val) exitWith { true };
false;
