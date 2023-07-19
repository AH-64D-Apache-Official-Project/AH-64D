/* ----------------------------------------------------------------------------
Function: fza_audio_fnc_addCaution

Description:

Parameters:
    _heli: object - the apache the player is in

Returns:
    No returns

Examples:
    [_heli] call fza_audio_fnc_addCaution;
Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

_heli setvariable ["fza_audio_caution", true];

private _funcHook = _heli getVariable ["fza_audio_funcHook", scriptNull];
if (scriptDone _funcHook) then {
    _funcHook = [_heli] spawn fza_audio_fnc_update;
    _heli setVariable ["fza_audio_funcHook", _funcHook];
};