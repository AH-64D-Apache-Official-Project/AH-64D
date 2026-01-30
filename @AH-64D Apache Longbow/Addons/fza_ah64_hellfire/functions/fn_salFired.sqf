/* ----------------------------------------------------------------------------
Function: fza_hellfire_fnc_salFired

Description:
    Initialises the seeker of the ACE SAL hellfire for the apache

Parameters:
    _heli - The helicopter to modify

Returns:
    Nothing

Examples:
    --- Code
    [_heli] call fza_hellfire_fnc_salFired
    ---

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["", "_launchParams"];
_launchParams params ["_shooter","","","_attackProfile","","_laserinfo"];

#define SCALE_METERS_KM 0.001
#define SCALE_KM_TOF 4

private _heli = vehicle _shooter;
private _attackProfile = [_heli] call fza_hellfire_fnc_getattackProfile;
private _lasePos       = [_heli] call fza_hellfire_fnc_salLasePos;
private _currentTof    = _heli getVariable "fza_ah64_tofCountDown";

if !isNil "_lasePos" then {
    _attackProfile = "hellfire";
    _currentTof pushBack (cba_missiontime + (_lasePos distance _heli) * SCALE_METERS_KM * SCALE_KM_TOF);
    _heli setvariable ["fza_ah64_tofCountDown", _currentTof];
};

_launchParams set [3, _attackProfile];

//Grab and set laser code for hellfire
_index = _heli getVariable "fza_ah64_laserMissilePrimaryCode";

if !(_index == -1) then {
    private _channels = _heli getVariable "fza_ah64_laserChannelCodes";
    private _hash = _heli getVariable "fza_ah64_laserChannelIndex";
    private _laserCode = _hash get _channels # _index;
    private _laserInfo = [_laserCode, ACE_DEFAULT_LASER_WAVELENGTH, ACE_DEFAULT_LASER_WAVELENGTH];
    _launchParams set [5, _laserInfo];
} else {
    //create no code launch
    _launchParams set [5, [99999999, ACE_DEFAULT_LASER_WAVELENGTH, ACE_DEFAULT_LASER_WAVELENGTH]];
};