/* ----------------------------------------------------------------------------
Function: fza_fnc_sign

Description:
    Returns the sign of a number

Parameters:
    _val = The number  

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_val"];

private _return = 0;

if (_val > 0) then { _return =  1; };
if (_val < 0) then { _return = -1; };

_return;