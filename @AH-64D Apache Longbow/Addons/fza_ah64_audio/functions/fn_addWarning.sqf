/* ----------------------------------------------------------------------------
Function: fza_audio_fnc_addWarning

Description:

Parameters:
    _heli: object - the apache the player is in

Returns:
    No returns

Examples:

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_priority", "_Reference"];

private _wrnMsg = _heli getVariable "fza_audio_warning_message";

if (_wrnMsg == "") then {
    _heli setvariable ["fza_audio_ase_message", _this];
};

private _funcHook = _heli getVariable ["fza_audio_funcHook", scriptNull];
if (scriptDone _funcHook) then {
    _funcHook = [_heli] spawn fza_audio_fnc_audioHandler;
    _heli setVariable ["fza_audio_funcHook", _funcHook];
};