/* ----------------------------------------------------------------------------
Function: fza_betty_fnc_playsystemAudio

Description:

Parameters:
    _heli: object - the apache the player is in

Returns:
    No returns

Examples:

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

while !(player == vehicle player) do {
    private _aseMsg = _heli getVariable "fza_audio_ase_message";
    private _wrnMsg = _heli getVariable "fza_audio_warning_message";

    if !(_aseMsg # 0 == []) then {
        playSound _aseMsg ;
        _heli setvariable ["fza_audio_ase_message", []];
        sleep str _aseMsg # 1;
        continue;
    };
    if !(_wrnMsg # 0 == []) then {
        playSound _aseMsg # 0;
        sleep _aseMsg # 1;
        continue;
    };
    if (_heli getVariable "fza_audio_caution") then {
        playSound "fza_ah64_Caution";
        sleep 1.8;
        continue;
    };
    break;
};