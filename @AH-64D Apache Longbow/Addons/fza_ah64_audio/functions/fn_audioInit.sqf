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

//Todo
//Creation of interactable coms panel
//need either a scroll wheel interact or cycle interact 10-100%

//System volume
private _mastervolume = 0.8;

//Acre Radio volume
_heli setVariable ["fza_ah64_radioVolume", createHashMapFromArray
    [ ["VHF", (1 * _mastervolume)],["UHF", (1 * _mastervolume)],
      ["FM1", (1 * _mastervolume)],["FM2", (1 * _mastervolume)]
    ], true];
    
//Acre Radio squelch
_heli setVariable ["fza_ah64_radioSquelch", createHashMapFromArray
    [ ["VHF",true],["UHF",true],["FM1",true],["FM2",true]], true];