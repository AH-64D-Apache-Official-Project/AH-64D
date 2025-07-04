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

_heli setVariable ["fza_sfmplus_reqEngTorque",   [0.0, 0.0]];

_heli setVariable ["fza_sfmplus_vrsVelocityMin", 0.0];
_heli setVariable ["fza_sfmplus_vrsVelocityMax", 0.0];

_heli setVariable ["fza_sfmplus_rtrThrust",      [0.0, 0.0]];
_heli setVariable ["fza_sfmplus_rtrRPM",         0.0];

_heli setVariable ["fza_sfmplus_rtrMoi",         [0.0, 0.0]];