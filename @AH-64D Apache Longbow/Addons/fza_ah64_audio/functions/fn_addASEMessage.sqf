/* ----------------------------------------------------------------------------
Function: fza_audio_fnc_addASEMessage

Description:

Parameters:
    _heli: object - the apache the player is in
    _priority: Number - message priorty
    _audio: string - Cfg Audio name
    _audiolength: number - Length of audio file 

Returns:
    No returns

Examples:
    [_heli, 6, _hostile, _identity, 1, _dirAud, 1.3, "fza_ah64_launch", 0.65] call fza_audio_fnc_addASEMessage;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_priority", "_reference"];

private _aseMsg     = _heli getVariable "fza_audio_ase_message";
//private _ComsVolume = _heli getVariable "fza_ah64_comsVolume";
//private _volume     = _ComsVolume get "RLWR";
private _volume     = fza_ah64_volumeRlwr;
_this insert [3, [_volume]];

if (_aseMsg isEqualTo "" || {_priority > _aseMsg # 1}) then {
    _heli setvariable ["fza_audio_ase_message", _this];
};

private _funcHook = _heli getVariable ["fza_audio_funcHook", scriptNull];
if (scriptDone _funcHook) then {
    _funcHook = [_heli] spawn fza_audio_fnc_audioHandler;
    _heli setVariable ["fza_audio_funcHook", _funcHook];
};