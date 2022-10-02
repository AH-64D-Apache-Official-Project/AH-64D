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

if (_missilelobl == true && (lasertarget _heli distance2d _heli) <= 1500 && _attackProfile == "Hellfire_hi") then {
	_attackProfile = "hellfire";
};
if (_missilelobl == true && (lasertarget _heli distance2d _heli) <= 750 && _attackProfile == "Hellfire_lo") then {
	_attackProfile = "hellfire";
};

_launchParams set [3, _attackProfile];

//Grab and set laser code for hellfire

private _index = 0;
if !(isNull laserTarget _heli) then {
	_index = _heli getvariable "fza_ah64_laserMissilePrimaryCode";
} else {
	_index = _heli getvariable "fza_ah64_laserMissileAlternateCode";
};

private _channels = _heli getvariable "fza_ah64_laserChannelCodes";
private _hash = _heli getvariable "fza_ah64_LaserChannelIndex";
private _laserCode = _hash get _channels # _index;
private _laserInfo 	= [_laserCode, ACE_DEFAULT_LASER_WAVELENGTH, ACE_DEFAULT_LASER_WAVELENGTH];

_launchParams set [5, _laserInfo];