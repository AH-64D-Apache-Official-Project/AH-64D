/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_salOnFired
Description: Initialises the SAL hellfire seeker at launch. Sets attack
    profile, laser code, and TOF counter.
Parameters: _launchParams - ACE launch params (mutated in-place)
Returns: Nothing
Author: Snow(Dryden)
---------------------------------------------------------------------------- */
params ["", "_launchParams"];
_launchParams params ["_shooter","","","_attackProfile","","_laserinfo"];

#define SCALE_METERS_KM 0.001
#define SCALE_KM_TOF    4

private _heli          = vehicle _shooter;
private _attackProfile = [_heli] call fza_hellfire_fnc_trajectoryToAceProfile;
private _lasePos       = [_heli] call fza_hellfire_fnc_salFindLaserDesignation;
private _currentTof    = _heli getVariable "fza_ah64_tofCountDown";

if (!isNil "_lasePos") then {
    _attackProfile = "hellfire";
    _currentTof pushBack (CBA_missionTime + (_lasePos distance _heli) * SCALE_METERS_KM * SCALE_KM_TOF);
    _heli setVariable ["fza_ah64_tofCountDown", _currentTof];
};

_launchParams set [3, _attackProfile];

// Set laser code for hellfire seeker
private _index = _heli getVariable "fza_ah64_laserMissilePrimaryCode";

if (_index != -1) then {
    private _channels   = _heli getVariable "fza_ah64_laserChannelCodes";
    private _hash       = _heli getVariable "fza_ah64_laserChannelIndex";
    private _laserCode  = _hash get (_channels # _index);
    _launchParams set [5, [_laserCode, ACE_DEFAULT_LASER_WAVELENGTH, ACE_DEFAULT_LASER_WAVELENGTH]];
} else {
    // No valid code: use impossible code so seeker finds nothing
    _launchParams set [5, [99999999, ACE_DEFAULT_LASER_WAVELENGTH, ACE_DEFAULT_LASER_WAVELENGTH]];
};

// Shot-at file
private _targetPos         = [0, 0, 0];
private _remoteEngagement  = true;
if (!isNil "_lasePos" && !isNull laserTarget _heli) then {
    _targetPos        = _lasePos;
    _remoteEngagement = false;
};
[_heli, [dayTime, "HH:MM:SS"] call BIS_fnc_timeToString, _targetPos, _remoteEngagement] call fza_dms_fnc_addShotSAL;
