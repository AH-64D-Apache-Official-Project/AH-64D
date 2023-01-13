/* ----------------------------------------------------------------------------
Function: fza_betty_fnc_systemAudioHandler

Description:
    1 - caution
    2 - warning
    3 - ase search
    4 - ase aquire
    5 - ase track 
    6 - ase launch
    7 - ase power 

Parameters:
    _heli: object - the apache the player is in

Returns:
    No returns

Examples:

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

while {player != vehicle player} do {
    waituntil {isGamePaused == false};   
    
    private _aseMsg = _heli getVariable "fza_audio_ase_message";
    private _wrnMsg = _heli getVariable "fza_audio_warning_message";

    if (_aseMsg != []) then {
        [_aseMsg] spawn fza_betty_fnc_playaudio;
        _heli setvariable ["fza_audio_ase_message", []];
        sleep (_aseMsg # 4 + _aseMsg # 6 + _aseMsg # 8);
        continue;
    };
    if (_wrnMsg != []) then {
        [_wrnMsg] spawn fza_betty_fnc_playaudio;
        sleep (_wrnMsg # 4 + _wrnMsg # 6 + _wrnMsg # 8);
        continue;
    };
    if (_heli getVariable "fza_audio_caution") then {
        playSound "fza_ah64_Caution";
        sleep 1.8;
        continue;
    };
    break;
};