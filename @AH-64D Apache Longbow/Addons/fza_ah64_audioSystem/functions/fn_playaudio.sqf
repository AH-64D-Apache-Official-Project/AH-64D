/* ----------------------------------------------------------------------------
Function: fza_betty_fnc_playaudio

Description:

Parameters:
    _heli: object - the apache the player is in

Returns:
    No returns

Examples:

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params [["_heli", vehicle player, ["Object"]], ["_priority", 1, ["number"]], ["_Reference", "", ["string"]], ["_audio1", "", ["string"]], ["_delay1", 1], ["_audio2", "", ["string"]], ["_delay2", 1], ["_audio3", "", ["string"]], ["_delay3", 1]];

if (vehicle player == _heli && _audio1 != "") then {
    playSound _audio1;
    sleep _delay1;
};
if (vehicle player == _heli && _audio2 != "") then {
    playSound _audio2;
    sleep _delay2;
};
if (vehicle player == _heli && _audio3 != "") then {
    playSound _audio3;
    sleep _delay3;
};