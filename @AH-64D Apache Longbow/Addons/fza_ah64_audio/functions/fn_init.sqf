/* ----------------------------------------------------------------------------
Function: fza_audio_fnc_init

Description:

Parameters:
    initilizes the values for the helicopter

Returns:
    No returns

Examples:

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

if (!(_heli getVariable ["fza_ah64_audioInitialised", false]) && local _heli) then {
    _heli setVariable ["fza_ah64_audioInitialised", true, true];

    _heli setvariable ["fza_audio_ase_message", "", true];
    _heli setvariable ["fza_audio_warning_message", "", true];
    _heli setvariable ["fza_audio_caution", false, true];
    _heli setvariable ["fza_audio_funcHook", scriptNull, true];

    //Coms Panel Volume
    _heli setVariable ["fza_ah64_comsVolume", createHashMapFromArray
        [ ["Master", 3],["RLWR", 3],
        ["VHF", 1],["UHF", 1],
        ["FM1", 1],["FM2", 1]
        ], true];
        
    //Coms Panel Squelch
    _heli setVariable ["fza_ah64_radioSquelch", createHashMapFromArray
        [ ["VHF",true],["UHF",true],["FM1",true],["FM2",true]], true];
};