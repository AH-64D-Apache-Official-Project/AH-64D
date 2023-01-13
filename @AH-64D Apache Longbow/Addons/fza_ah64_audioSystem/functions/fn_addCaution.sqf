/* ----------------------------------------------------------------------------
Function: fza_betty_fnc_addCaution

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

_heli setvariable ["fza_audio_caution", true];

[_heli] spawn fza_betty_fnc_systemAudioHandler