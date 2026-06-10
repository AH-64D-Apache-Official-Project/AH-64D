/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_rotorVariables

Description:
    Defines core rotor variables.

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

// Static arrays sized for up to 6 rotors, indexed by rotor index
// Per-blade accumulated aerodynamic flap moments (N·m), one 4-element array per rotor
_heli setVariable ["fza_sfmplus_rotorFlapMoment",  [[0.0,0.0,0.0,0.0]
                                                   ,[0.0,0.0,0.0,0.0]
                                                   ,[0.0,0.0,0.0,0.0]
                                                   ,[0.0,0.0,0.0,0.0]
                                                   ,[0.0,0.0,0.0,0.0]
                                                   ,[0.0,0.0,0.0,0.0]]];
// Azimuth (degrees) at which each virtual blade's moment was computed
_heli setVariable ["fza_sfmplus_rotorBladeAzimuth",[[0.0,0.0,0.0,0.0]
                                                   ,[0.0,0.0,0.0,0.0]
                                                   ,[0.0,0.0,0.0,0.0]
                                                   ,[0.0,0.0,0.0,0.0]
                                                   ,[0.0,0.0,0.0,0.0]
                                                   ,[0.0,0.0,0.0,0.0]]];
// Fixed-frame flap coefficients (degrees) — updated each frame from decomposed blade moments
_heli setVariable ["fza_sfmplus_rotorBeta0",       [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]]; // collective coning
_heli setVariable ["fza_sfmplus_rotorA1",          [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]]; // longitudinal disc tilt
_heli setVariable ["fza_sfmplus_rotorB1",          [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]]; // lateral disc tilt
// Pre-filter targets — smoothed over one rotor revolution before the main disc tilt filter
_heli setVariable ["fza_sfmplus_rotorBeta0Target", [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
_heli setVariable ["fza_sfmplus_rotorA1Target",    [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
_heli setVariable ["fza_sfmplus_rotorB1Target",    [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
