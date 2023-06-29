/* ----------------------------------------------------------------------------
Function: fza_audio_fnc_audioInit

Description:

Parameters:
    _heli: object - the apache the player is in

Returns:
    No returns

Examples:

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

_heli setvariable ["fza_audio_advisory_message", "", true];
_heli setvariable ["fza_audio_ase_message", "", true];
_heli setvariable ["fza_audio_warning_message", "", true];
_heli setvariable ["fza_audio_caution", false, true];
_heli setvariable ["fza_audio_funcHook", scriptNull, true];