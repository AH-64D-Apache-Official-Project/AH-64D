/* ----------------------------------------------------------------------------
Function: fza_audioSystem_fnc_addCaution

Description:

Parameters:
    _heli: object - the apache the player is in

Returns:
    No returns

Examples:
    [_heli] call fza_audioSystem_fnc_addCaution;
Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

_heli setvariable ["fza_audio_caution", true];

private _FuncHook = _heli getVariable ["fza_audio_FuncHook", scriptNull];
if (scriptDone _FuncHook) then {
    _FuncHook = [_heli] spawn fza_audioSystem_fnc_audioSystemHandler;
    _heli setVariable ["fza_audio_FuncHook", _FuncHook];
};