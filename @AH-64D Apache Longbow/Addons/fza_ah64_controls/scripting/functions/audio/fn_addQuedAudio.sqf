/* ----------------------------------------------------------------------------
Function: fza_fnc_addQuedAudio

Description:
    takes input and adds it to the audio que

Parameters:
    _heli: object - the apache the player is in
    _audio: name - cfgsound name
    _audiodelay: number

Returns:
    No returns

Examples:
    [_audio1, _audio1delay, _audio2, _audio2Delay, _audio3, _audio3Delay, _priority, _audioReference] call fza_fnc_addQuedAudio;

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params [["_audio1", ""], ["_audio1Delay", 0], ["_audio2", ""], ["_audio2Delay", 0], ["_audio3", ""], ["_audio3Delay", 0], ["_priority", 2], ["_audioReference",""]];

_heli = vehicle player;
_insert = [_audio1, _audio1delay, _audio2, _audio2Delay, _audio3, _audio3Delay, _priority, _audioReference];
_heli setvariable ["fza_ah64_audioQueList", (_heli getVariable "fza_ah64_audioQueList") + [_insert]];