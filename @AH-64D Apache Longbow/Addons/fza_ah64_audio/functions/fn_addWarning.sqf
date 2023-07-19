/* ----------------------------------------------------------------------------
Function: fza_audio_fnc_addWarning

Description:

Parameters:
    _heli: object - the apache the player is in
    _priority: Number - message priorty
    _audio: string - Cfg Audio File
    _audiolength: number - Length of audio file 

Returns:
    No returns

Examples:
    [_heli, 6, _audio, _audiolength] call fza_audio_fnc_addWarning;

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_priority", "_audio", "_audiolength"];

private _wrnMsg = _heli getVariable "fza_audio_warning_message";

if (_wrnMsg isEqualTo "" || {_priority > _wrnMsg # 1}) then {
    _heli setvariable ["fza_audio_warning_message", _this];
};

private _funcHook = _heli getVariable ["fza_audio_funcHook", scriptNull];
if (scriptDone _funcHook) then {
    _funcHook = [_heli] spawn fza_audio_fnc_update;
    _heli setVariable ["fza_audio_funcHook", _funcHook];
};