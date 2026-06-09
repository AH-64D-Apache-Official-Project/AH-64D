/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_syncAceMissileParams
Description: Syncs ACE laser code and attack profile with current weapon state.
    Called once per frame.
Parameters: _heli - The helicopter
Returns: Nothing
Author: Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

private _channel = _heli getVariable "fza_ah64_laserLRFDCode";
private _hash    = _heli getVariable "fza_ah64_laserChannelIndex";
private _code    = _hash get _channel;
_heli setVariable ["ace_laser_code", _code];

private _attackProfile = [_heli] call fza_hellfire_fnc_trajectoryToAceProfile;
if (_attackProfile isEqualType "") then {
    _heli setVariable ["ace_missileguidance_attackProfile", _attackProfile];
};
