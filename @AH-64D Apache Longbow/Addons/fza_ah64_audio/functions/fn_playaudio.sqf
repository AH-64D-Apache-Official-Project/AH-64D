/* ----------------------------------------------------------------------------
Function: fza_audio_fnc_playaudio

Description:

Parameters:
    _heli: object - the apache the player is in

Returns:
    When complete - true

Examples:

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params [["_heli", vehicle player], ["_priority", 1], ["_Reference", ""], ["_volume", 1], ["_audio1", ""], ["_delay1", 1], ["_audio2", ""], ["_delay2", 1], ["_audio3", ""], ["_delay3", 1]];

if (vehicle player == _heli && _audio1 isNotEqualTo "") then {
    playSoundUI [_audio1, _volume];
    sleep _delay1;
};
if (vehicle player == _heli && _audio2 isNotEqualTo "") then {
    playSoundUI [_audio2, _volume];
    sleep _delay2;
};
if (vehicle player == _heli && _audio3 isNotEqualTo "") then {
    playSoundUI [_audio3, _volume];
    sleep _delay3;
};
true;