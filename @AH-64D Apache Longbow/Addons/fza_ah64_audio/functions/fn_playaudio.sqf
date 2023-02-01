/* ----------------------------------------------------------------------------
Function: fza_audio_fnc_playaudio

Description:

Parameters:
    _heli: object - the apache the player is in

Returns:
    No returns

Examples:

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params [["_heli", vehicle player], ["_priority", 1], ["_Reference", ""], ["_audio1", ""], ["_delay1", 1], ["_audio2", ""], ["_delay2", 1], ["_audio3", ""], ["_delay3", 1]];

if (vehicle player == _heli && _audio1 isNotEqualTo "") then {
    playSound _audio1;
    sleep _delay1;
};
if (vehicle player == _heli && _audio2 isNotEqualTo "") then {
    playSound _audio2;
    sleep _delay2;
};
if (vehicle player == _heli && _audio3 isNotEqualTo "") then {
    playSound _audio3;
    sleep _delay3;
};