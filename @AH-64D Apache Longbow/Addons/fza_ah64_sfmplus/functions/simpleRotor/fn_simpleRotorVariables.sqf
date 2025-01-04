/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_simpleRotorVariables

Description:
    Defines required simple rotor variables and initializes them.

Parameters:
    _heli - The helicopter to get information from [Unit].

Returns:
    ...

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_heli"];

_heli setVariable ["fza_sfmplus_rtrEngTq",      0.0];

_heli setVariable ["fza_sfmplus_rtrThrust",     [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_rtrMOI",        [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_rtrTQ",         [0.0, 0.0]];