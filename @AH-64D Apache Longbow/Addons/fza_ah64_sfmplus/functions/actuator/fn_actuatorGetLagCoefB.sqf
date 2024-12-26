/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_engine

Description:
    Sourced from JSBSim.

Parameters:
    ...

Returns:
    Lag coeffient required for actuator simulation.

Examples:
    ...

Author:
    BradMick
---------------------------------------------------------------------------- */
params ["_lagVal"];

private _denom = 2.00 + fza_sfmplus_deltaTime * _lagVal;
private _cb    = (2.00 - fza_sfmplus_deltaTime * _lagVal) / _denom;

_cb;