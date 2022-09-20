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

//AttackProfile
private _attackProfile = [_heli] call fza_fnc_HellfireGetAttackProfile;
private _Channel = 1111;
if !(isNull laserTarget _heli) then {
	_Channel = _heli getvariable "fza_ah64_laserMissilePrimaryCode";
} else {
	_Channel = _heli getvariable "fza_ah64_laserMissileAlternateCode";
};
_launchParams set [3, _attackProfile];

//Grab Code
private _hash 	 	= _heli getvariable "fza_ah64_LaserChannelIndex";
private _laserCode 	= _hash get _Channel;
private _laserInfo 	= [_laserCode, ACE_DEFAULT_LASER_WAVELENGTH, ACE_DEFAULT_LASER_WAVELENGTH];
_launchParams set [5, _laserInfo];