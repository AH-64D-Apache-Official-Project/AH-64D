/* ----------------------------------------------------------------------------
Function: fza_audioSystem_fnc_audioSystemInit

Description:

Parameters:
    _heli: object - the apache the player is in

Returns:
    No returns

Examples:

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

_heli setvariable ["fza_audio_ase_message", "", true];
_heli setvariable ["fza_audio_warning_message", "", true];
_heli setvariable ["fza_audio_caution", false, true];
_heli setvariable ["fza_audio_FuncHook", scriptNull, true];