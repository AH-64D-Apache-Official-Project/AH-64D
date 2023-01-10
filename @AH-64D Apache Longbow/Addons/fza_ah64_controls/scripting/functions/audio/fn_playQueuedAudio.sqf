/* ----------------------------------------------------------------------------
Function: fza_fnc_playQueuedAudio

Description:
    sorts through an array or audio and plays thoese with the highest priority
    and deletes other audio requests with a lower priority with the same references
    Audio priority
    1 - misc 1
    2 - misc 2
    3 - engine audio 
    4 - ase search
    5 - ase aquire
    6 - ase track 
    7 - engine faillure warnings
    8 - engine fire warning
    9 - ase launch
    10- ase power 

Parameters:
    _heli: object - the apache the player is in
    _audio: name - cfgsound name
    _audiodelay: number

Returns:
    No returns

Examples:
    _insert = [ _priority, _audioKey, _audio1, _audio1delay, _audio2, _audio2Delay, _audio3, _audio3Delay];
    _heli setvariable ["fza_ah64_audioQueList", (_heli getVariable "fza_ah64_audioQueList") pushback _insert]

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

waitUntil {fza_ah64_audioPlaying == false};
fza_ah64_audioPlaying = true;

private _quedAudioarray = _heli getVariable "fza_ah64_audioQueList";
private _maxIndex = -1;
private _maxPriority = -1;
{
    if (_x select 6 > _maxPriority) then {

        _maxIndex = _forEachIndex;
        _maxPriority = _x select 6;
    };
} foreach _quedAudioarray;

if (_maxIndex == -1) exitWith {
    //Couldnt play any audio
    fza_ah64_audioPlaying = false;
};


_list = _quedAudioarray select _maxIndex;
_list params
    [ ["_priority", ""], ["_audioKey", 0]
    , ["_audio1", ""], ["_audio1Delay", 0]
    , ["_audio2", ""], ["_audio2Delay", 0]
    , ["_audio3", ""], ["_audio3Delay", 0]];

if (!(_audio1 == "")) then {
    playSound _audio1;
    sleep _audio1Delay;
};
if (!(_audio2 == "")) then {
    playSound _audio2;
    sleep _audio2Delay;
};
if (!(_audio3 == "")) then {
    playSound _audio3;
    sleep _audio3Delay;
};

_quedAudioarray deleteAt _maxIndex;
fza_ah64_audioPlaying = false;