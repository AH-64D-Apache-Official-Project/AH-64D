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