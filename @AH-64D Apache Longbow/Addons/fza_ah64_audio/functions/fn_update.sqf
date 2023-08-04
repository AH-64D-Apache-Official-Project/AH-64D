/* ----------------------------------------------------------------------------
Function: fza_audio_fnc_update

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

private _battBusOn = _heli getVariable "fza_systems_battBusOn";

while {player != vehicle player} do {
    waituntil {isGamePaused == false};   
    if !_battBusOn exitWith {};
    
    private _aseMsg      = _heli getVariable "fza_audio_ase_message";
    private _wrnMsg      = _heli getVariable "fza_audio_warning_message";
    private _ComsVolume  = _heli getVariable "fza_ah64_comsVolume";
    private _spacer1     = _heli getVariable "fza_audio_Spacer1";
    private _spacer2     = _heli getVariable "fza_audio_Spacer2";
    private _spacer3     = _heli getVariable "fza_audio_Spacer3";
    //private _volume      = _ComsVolume get "Master";
    private _volume      = fza_ah64_volumeMaster;
    private _missiontime = CBA_missionTime;

    if (_aseMsg isNotEqualTo "" && (_missiontime >= _spacer1)) then {
        _aseMsg spawn fza_audio_fnc_playaudio;
        _aseMsg params["", "", "", "", "", ["_delay1", 0], "", ["_delay2", 0], "", ["_delay3", 0]];
        _heli setvariable ["fza_audio_ase_message", ""];
        _heli setvariable ["fza_audio_Spacer1", (_missiontime + _delay1 + _delay2 + _delay3)];
    };
    if (_wrnMsg isNotEqualTo "" && (_missiontime >= _spacer2)) then {
        _wrnMsg params["", "", "_audio", ["_delay", 0]];
        playSoundUI [_audio, _volume]; 
        _heli setvariable ["fza_audio_Spacer2", (_missiontime + _delay)];
    };
    if (_heli getVariable "fza_audio_caution" && (_missiontime >= _spacer3)) then {
        _heli setvariable ["fza_audio_Spacer3", (_missiontime + 1.8)];
        playSoundUI ["fza_ah64_Caution", _volume];
    };
};