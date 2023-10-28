/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_getRtrRPM

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
params ["_heli"];

private _flightModel    = getText (configOf _heli >> "fza_flightModel");

private _rtrRPM = ((_heli animationPhase "mainRotorRPM") * 1.08) / 10;

_rtrRPM;