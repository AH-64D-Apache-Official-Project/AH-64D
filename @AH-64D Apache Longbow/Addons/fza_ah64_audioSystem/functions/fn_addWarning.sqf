/* ----------------------------------------------------------------------------
Function: fza_betty_fnc_addWarning

Description:

Parameters:
    _heli: object - the apache the player is in

Returns:
    No returns

Examples:

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_priority", "_Reference", "_audio1", "_delay1", "_audio2", "_delay2", "_audio3", "_delay3"];

private _wrnMsg = _heli getVariable "fza_audio_warning_message";

if (_wrnMsg == []) then {
    _heli setvariable ["fza_audio_ase_message", [_this]];
};

[_heli] spawn fza_betty_fnc_systemAudioHandler;
