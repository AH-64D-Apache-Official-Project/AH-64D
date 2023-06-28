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
    
    private _advMsg = _heli getVariable "fza_audio_advisory_message";
    private _aseMsg = _heli getVariable "fza_audio_ase_message";
    private _wrnMsg = _heli getVariable "fza_audio_warning_message";

    if (_advMsg isNotEqualTo "") then {
        _heli setvariable ["fza_audio_advisory_message", ""];
        playSound _advMsg # 3;
        continue;
    };
    if (_aseMsg isNotEqualTo "") then {
        _heli setvariable ["fza_audio_ase_message", ""];
        _aseMsg spawn fza_audio_fnc_playaudio;
        _aseMsg params ["","","","", ["_delay1", 1], "", ["_delay2", 1], "", ["_delay3", 1]];
        sleep (_delay1 + _delay2 + _delay3);
        continue;
    };
    if (_wrnMsg isNotEqualTo "") then {
        _wrnMsg spawn fza_audio_fnc_playaudio;
        _wrnMsg params ["","","","", ["_delay1", 1], "", ["_delay2", 1], "", ["_delay3", 1]];
        sleep (_delay1 + _delay2 + _delay3);
        continue;
    };
    if (_heli getVariable "fza_audio_caution") then {
        playSound "fza_ah64_Caution";
        sleep 1.8;
        continue;
    };
    break;
};