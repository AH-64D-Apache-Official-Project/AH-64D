/* ----------------------------------------------------------------------------
Function: fza_sfmplus_fnc_suspensionVariables

Description:
    Declares the variables used by the suspension system.
    
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
/*
_heli setVariable ["fza_sfmplus_wheelInitialized", [false,false,false]];
_heli setVariable ["fza_sfmplus_restCompression",  [0.0, 0.0, 0.0]];
_heli setVariable ["fza_sfmplus_prevCompression",  [0.0, 0.0, 0.0]];
_heli setVariable ["fza_sfmplus_contactFrames",    [0, 0, 0]];
_heli setVariable ["fza_sfmplus_hasLanded",        [false, false, false]];
*/

_heli setVariable ["fza_sfmplus_wheelPrevSuspDistance",     [0.0, 0.0, 0.0]];
_heli setVariable ["fza_sfmplus_springConstants",           [0.0, 0.0, 0.0]];
_heli setVariable ["fza_sfmplus_damperConstants",           [0.0, 0.0, 0.0]];

// Suspension frame counter for settling period
_heli setVariable ["fza_sfmplus_suspensionFrameCount", 0];

// Per-wheel settled state: once velocity stays below 0.05 m/s for 1 s, freeze the spring
// constant (eliminates getCenterOfMass noise) while keeping live compression (preserves
// roll/pitch restoring).  Disturbance detection is velocity-based (> 0.5 m/s) so only
// real impacts unsettle the wheel, not slow roll drift.
_heli setVariable ["fza_sfmplus_wheelSettled",    [false, false, false]];
_heli setVariable ["fza_sfmplus_wheelSettleTime", [0.0,   0.0,   0.0]];
_heli setVariable ["fza_sfmplus_wheelSettledK",   [0.0,   0.0,   0.0]];