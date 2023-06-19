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
params ["_deltaTime", "_lagVal"];

private _denom = 2.00 + _deltaTime * _lagVal;
private _cb    = (2.00 - _deltaTime * _lagVal) / _denom;

_cb;