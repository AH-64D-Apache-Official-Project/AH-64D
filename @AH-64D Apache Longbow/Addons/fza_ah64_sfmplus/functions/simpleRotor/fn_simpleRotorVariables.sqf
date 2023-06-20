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

_heli setVariable ["fza_sfmplus_mainRtrTorque",    0.0];
_heli setVariable ["fza_sfmplus_mainRtrMOI",       0.0];
_heli setVariable ["fza_sfmplus_mainRtrGearRatio", 0.0];