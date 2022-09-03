/* ----------------------------------------------------------------------------
Function: fza_fnc_playQuedAudio

Description:
    sorts through an array or audio and plays thoese with the highest priority
    and deletes other audio requests with a lower priority with the same references

Parameters:
    _heli: object - the apache the player is in
    _audio: name - cfgsound name
    _audiodelay: number

Returns:
    No returns

Examples:
    _insert = [_audio1, _audio1delay, _audio2, _audio2Delay, _audio3, _audio3Delay, _priority, _audioReference];
    _heli setvariable ["fza_ah64_audioQueList", (_heli getVariable "fza_ah64_audioQueList") pushback _insert]

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

if (fza_ah64_AudioPlaying == true) exitwith {};

private _quedAudioarray = _heli getVariable "fza_ah64_audioQueList"
private _maxIndex = -1;
private _maxPriority = -1;
{
    if (_x select 6 > _maxPriority) then {
        _maxIndex = _forEachIndex;
        _maxPriority = _x select 6;
    };
}

if (_maxIndex == -1) exitWith {};

//Set audio playing
fza_ah64_AudioPlaying = true;

_list = _quedAudioarray select _maxIndex;
_list params
    [ ["_audio1", ""], ["_audio1Delay", 0]
    , ["_audio2", ""], ["_audio2Delay", 0]
    , ["_audio3", ""], ["_audio3Delay", 0]
    , ["_priority", 2], ["_audioReference", ""]];

{
    if (_x select 7 == _audioReference) then{
        fza_ah64_audioArray deleteAt _forEachIndex;
    };
} forEach fza_ah64_audioArray;


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

fza_ah64_audioArray deleteAt _maxIndex;
fza_ah64_AudioPlaying = false;