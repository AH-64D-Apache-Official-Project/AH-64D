/* ----------------------------------------------------------------------------
Function: fza_audioSystem_fnc_addASEMessage

Description:

Parameters:
    _heli: object - the apache the player is in

Returns:
    No returns

Examples:

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_priority", "_Reference"];

private _aseMsg = _heli getVariable ["fza_audio_ase_message", ""];

if (_aseMsg isEqualTo "" or {_priority > _aseMsg # 1}) then {
    _heli setvariable ["fza_audio_ase_message", _this];
};

private _FuncHook = _heli getVariable ["fza_audio_FuncHook", scriptNull];
if (scriptDone _FuncHook) then {
    _FuncHook = [_heli] spawn fza_audioSystem_fnc_audioSystemHandler;
    _heli setVariable ["fza_audio_FuncHook", _FuncHook];
};