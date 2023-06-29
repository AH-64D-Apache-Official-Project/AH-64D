/* ----------------------------------------------------------------------------
Function: fza_audio_fnc_playAdvisory

Description:

Parameters:
    _heli: object - the apache the player is in

Returns:
    No returns

Examples:
    [_heli] call fza_audio_fnc_playAdvisory;

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _ComsVolume = vehicle player getVariable "fza_ah64_comsVolume";
private _volume     = _ComsVolume get "Master";

playSoundUI ["fza_ah64_Flight_control", _volume];