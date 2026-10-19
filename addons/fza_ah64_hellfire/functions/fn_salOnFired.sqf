/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_salOnFired
Description: Initialises the SAL hellfire seeker at launch. Sets attack
    profile, laser code, and TOF counter.
Parameters: _firedEH      - Full ACE fired-EH array
            _launchParams - ACE launch params (mutated in-place)
Returns: Nothing
Author: Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_firedEH", "_launchParams"];
_launchParams params ["_shooter"];
_firedEH params ["", "", "", "", "_ammo", "_magazine", "_projectile"];

private _heli          = vehicle _shooter;
private _attackProfile = [_heli] call fza_hellfire_fnc_trajectoryToAceProfile;
private _lasePos       = [_heli] call fza_hellfire_fnc_salFindLaserDesignation;

// Locked on before launch (LOBL) it flies direct to the spot; otherwise (LOAL) the selected trajectory to the range
// source range
private _tofRange = ([_heli, _shooter] call fza_fnc_targetingRange) # 0;
if (!isNil "_lasePos") then {
    _attackProfile = "hellfire";
    _tofRange      = _lasePos distance _heli;
};
// HF TOF from the launch conditions: the range to the target and the trajectory flown
[_heli, [_ammo, _magazine, _tofRange, _attackProfile] call fza_hellfire_fnc_tofEstimate] call fza_hellfire_fnc_tofStart;

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
