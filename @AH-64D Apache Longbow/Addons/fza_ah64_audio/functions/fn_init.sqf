/* ----------------------------------------------------------------------------
Function: fza_audio_fnc_audioInit

Description:
    Initialize public variables on mission startup
    To set up information accessible by all crew members

Parameters:
    _heli - The helicopter upon which to execute the code

Returns:
    No returns

Examples:

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

_heli setvariable ["fza_audio_ase_message",     "",         true];
_heli setvariable ["fza_audio_warning_message", "",         true];
_heli setvariable ["fza_audio_caution",         false,      true];
_heli setvariable ["fza_audio_funcHook",        scriptNull, true];

//Todo
//Creation of interactable coms panel
//need either a scroll wheel interact or cycle interact 10-100%

//Coms Panel Volume
_heli setVariable ["fza_ah64_comsVolume", createHashMapFromArray
    [ ["Master", 3],["RLWR", 3],
      ["VHF", 1],["UHF", 1],
      ["FM1", 1],["FM2", 1]
    ], true];
    
//Coms Panel Squelch
_heli setVariable ["fza_ah64_radioSquelch", createHashMapFromArray
    [ ["VHF",true],["UHF",true],["FM1",true],["FM2",true]], true];

//- Sound Controller Handler
    ["fza_updateArrayVariable", fza_audio_fnc_updateEngineSoundController] call CBA_fnc_addEventHandler;