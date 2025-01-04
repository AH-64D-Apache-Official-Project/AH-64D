/* ----------------------------------------------------------------------------
Function: bmkhs_sfmplus_fnc_getRtrRPM

Description:
    Returns the rotor RPM depending on the simulation being used

Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    Rotor rpm

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_val"];

if (_val isEqualType "SCALAR" || _val isEqualType "NAN") exitwith { true };
false;