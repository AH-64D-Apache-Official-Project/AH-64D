/* ----------------------------------------------------------------------------
Function: fza_audio_fnc_flightTone

Description:
    plays the flight tone in both crew seats

Parameters:
    _heli: object - the apache the player is in

Returns:
    No returns

Examples:
    [_heli] call fza_audio_fnc_flightTone;
Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params["_heli"];

[["fza_ah64_flight_control", fza_ah64_volumeMaster]] remoteExec ["playSoundUI", [driver _heli, gunner _heli]];