/* ----------------------------------------------------------------------------
Function: fza_fnc_hellfireSALFired

Description:
    The handling of Ace Laser Seeker for our Systems

Parameters:
    _heli - The helicopter to modify

Returns:
	Nothing

Examples:
	--- Code
    [_heli] call fza_fnc_hellfireSALFired
	---

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["", "_launchParams"];
_launchParams params ["_shooter","","","_attackProfile","","_laserinfo"];

_heli = vehicle _shooter;
private _missilelobl = _heli getVariable "fza_ah64_missleLOBL";

//AttackProfile
private _attackProfile = [_heli] call fza_fnc_HellfireGetAttackProfile;

if (_missilelobl == true) then {
	_attackProfile = "hellfire";
};

_launchParams set [3, _attackProfile];

//Grab and set laser code for hellfire
_index = _heli getvariable "fza_ah64_laserMissilePrimaryCode";

if !(_index == -1) then {
	private _channels = _heli getvariable "fza_ah64_laserChannelCodes";
	private _hash = _heli getvariable "fza_ah64_LaserChannelIndex";
	private _laserCode = _hash get _channels # _index;
	private _laserInfo 	= [_laserCode, ACE_DEFAULT_LASER_WAVELENGTH, ACE_DEFAULT_LASER_WAVELENGTH];
	_launchParams set [5, _laserInfo];
} else {
	//create no code launch	
	_launchParams set [5, [99999999, ACE_DEFAULT_LASER_WAVELENGTH, ACE_DEFAULT_LASER_WAVELENGTH]];
};