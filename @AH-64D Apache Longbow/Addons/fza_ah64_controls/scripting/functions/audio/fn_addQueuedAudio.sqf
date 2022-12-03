/* ----------------------------------------------------------------------------
Function: fza_fnc_addQueuedAudio

Description:
    takes input and adds it to the audio queue
    _audioKey, is an identifying key used to track and prevent audio from playing should overlapping audio with identical keys be present, the older key with and equal or lower priority will be removed from the queue

Parameters:
    _heli: object - the apache the player is in
    _audio: name - cfgsound name
    _audiodelay: number

Returns:
    No returns

Examples:
    [_heli, _priority, _audioKey, _audio1, _audio1delay, _audio2, _audio2Delay, _audio3, _audio3Delay] call fza_fnc_addQueuedAudio;

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", ["_priority", 2], ["_audioKey",""], ["_audio1", ""], ["_audio1Delay", 0], ["_audio2", ""], ["_audio2Delay", 0], ["_audio3", ""], ["_audio3Delay", 0]];


private _quedAudioarray = _heli getVariable "fza_ah64_audioQueList";
{
    if ((_x select 7 == _audioKey) && (_x select 6 <= (_priority + 1))) then {
        _quedAudioarray deleteAt _foreachindex;
    };
} forEach _quedAudioarray;

_insert = [_priority, _audioKey, _audio1, _audio1delay, _audio2, _audio2Delay, _audio3, _audio3Delay];
_heli setvariable ["fza_ah64_audioQueList", (_heli getVariable "fza_ah64_audioQueList") + [_insert]];

[_heli] spawn fza_fnc_playQueuedAudio;