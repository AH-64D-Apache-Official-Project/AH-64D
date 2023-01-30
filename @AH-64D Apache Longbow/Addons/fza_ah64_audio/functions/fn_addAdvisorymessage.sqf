/* ----------------------------------------------------------------------------
Function: fza_audioSystem_fnc_addAdvisoryMessage

Description:

Parameters:
    _heli: object - the apache the player is in
    _priority: Number - message priorty
    _reference: string - reference string to compair against identical audio requests

Returns:
    No returns

Examples:
    [_heli, 1, "", "fza_ah64_Flight_control"] call fza_audioSystem_fnc_addASEMessage;

Author:
    Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli", "_priority","_reference"];

private _advMsg = _heli getVariable "fza_audio_advisory_message";

if (_aseMsg isEqualTo "" or {_priority > _aseMsg # 1}) then {
    _heli setvariable ["fza_audio_advisory_message", _this];
};

private _funcHook = _heli getVariable ["fza_audio_funcHook", scriptNull];
if (scriptDone _funcHook) then {
    _funcHook = [_heli] spawn fza_audioSystem_fnc_audioSystemHandler;
    _heli setVariable ["fza_audio_funcHook", _funcHook];
};