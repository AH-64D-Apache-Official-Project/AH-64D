/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_perfVariables

Description:
    Defines the initial performance page variables and initializes them.

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

_heli setVariable ["fza_sfmplus_fwdFuelMass",    0.0];
_heli setVariable ["fza_sfmplus_ctrFuelMass",    0.0];
_heli setVariable ["fza_sfmplus_aftFuelMass",    0.0];

_heli setVariable ["fza_sfmplus_stn1FuelMass",   0.0];
_heli setVariable ["fza_sfmplus_stn2FuelMass",   0.0];
_heli setVariable ["fza_sfmplus_stn3FuelMass",   0.0];
_heli setVariable ["fza_sfmplus_stn4FuelMass",   0.0];

_heli setVariable ["fza_sfmplus_totFuelMass",    0.0];
_heli setVariable ["fza_sfmplus_maxTotFuelMass", 0.0];