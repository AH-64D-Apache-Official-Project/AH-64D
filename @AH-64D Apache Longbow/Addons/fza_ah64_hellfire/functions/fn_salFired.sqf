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
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["", "_launchParams"];
_launchParams params ["_shooter","","","_attackProfile","","_laserinfo"];

_heli = vehicle _shooter;

//AttackProfile
private _attackProfile = [_heli] call fza_hellfire_fnc_getattackProfile;

if (_missilelobl) then {
	_attackProfile = "hellfire";
};

_launchParams set [3, _attackProfile];

//Grab and set laser code for hellfire
_index = _heli getVariable "fza_ah64_laserMissilePrimaryCode";

if !(_index == -1) then {
	private _channels = _heli getVariable "fza_ah64_laserChannelCodes";
	private _hash = _heli getVariable "fza_ah64_laserChannelIndex";
	private _laserCode = _hash get _channels # _index;
	private _laserInfo 	= [_laserCode, ACE_DEFAULT_LASER_WAVELENGTH, ACE_DEFAULT_LASER_WAVELENGTH];
	_launchParams set [5, _laserInfo];
} else {
	//create no code launch	
	_launchParams set [5, [99999999, ACE_DEFAULT_LASER_WAVELENGTH, ACE_DEFAULT_LASER_WAVELENGTH]];
};