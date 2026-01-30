/* ----------------------------------------------------------------------------
Function: fza_audio_fnc_flightTone

Description:
    plays the flight tone in both crew seats

Parameters:
    _heli: object - the apache the player is in

Returns:
    No returns

Examples:
    [_heli] spawn fza_audio_fnc_flightTone;
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

private _tonePlaying = _heli getVariable ["fza_ah64_flightTonePlaying", false];

if !_tonePlaying then {
    _heli setVariable ["fza_ah64_flightTonePlaying", true];
    [["fza_ah64_flight_control", fza_ah64_volumeMaster]] remoteExec ["playSoundUI", [driver _heli, gunner _heli]];
    sleep 0.5;
    _heli setVariable ["fza_ah64_flightTonePlaying", false];
};