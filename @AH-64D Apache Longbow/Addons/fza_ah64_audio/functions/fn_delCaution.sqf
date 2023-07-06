/* ----------------------------------------------------------------------------
Function: fza_audio_fnc_delCaution

Description:

Parameters:
    _heli: object - the apache the player is in

Returns:
    No returns

Examples:
    [_heli] call fza_audio_fnc_delCaution;
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

_heli setvariable ["fza_audio_caution", false];