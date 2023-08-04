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

private _otherTurret = [_heli, true] call fza_fnc_currentTurret;
"fza_ah64_flight_control" remoteExec ["playsound", _heli turretUnit _otherTurret];
playsound "fza_ah64_flight_control";