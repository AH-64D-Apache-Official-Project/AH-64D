/* ----------------------------------------------------------------------------
Function: fza_audio_fnc_audioHandler

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
    private _funcHook = _heli getVariable ["fza_audio_funcHook", scriptNull];
    if (scriptDone _funcHook) then {
        _funcHook = [_heli] spawn fza_audio_fnc_audioHandler;
        _heli setVariable ["fza_audio_funcHook", _funcHook];
    };

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

while {player != vehicle player} do {
    waituntil {isGamePaused == false};   
    
    private _aseMsg     = _heli getVariable "fza_audio_ase_message";
    private _wrnMsg     = _heli getVariable "fza_audio_warning_message";
    private _ComsVolume = _heli getVariable "fza_ah64_comsVolume";
    private _volume     = _ComsVolume get "Master";

    if (_aseMsg isNotEqualTo "") then {
        _done = _aseMsg spawn fza_audio_fnc_playaudio;
        waitUntil {scriptDone _done};
        _heli setvariable ["fza_audio_ase_message", ""];
        continue;
    };
    if (_wrnMsg isNotEqualTo "") then {
        playSoundUI [_wrnMsg # 2, _volume];
        sleep (_wrnMsg # 3);
        continue;
    };
    if (_heli getVariable "fza_audio_caution") then {
        playSoundUI ["fza_ah64_Caution", _volume];
        sleep 1.8;
        continue;
    };
    break;
};