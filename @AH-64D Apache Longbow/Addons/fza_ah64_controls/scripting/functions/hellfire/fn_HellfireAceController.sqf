/* ----------------------------------------------------------------------------
Function: fza_fnc_HellfireAceController

Description:
	Used to set the Configure ace with our systems

Parameters:
    _heli - the helicopter

Returns:
	Nothing

Examples:
	[_heli] call fza_fnc_HellfireAceController;

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

//Laser designator
_Channel = _heli getvariable "fza_ah64_laserLRFDCode";
_hash = _heli getvariable "fza_ah64_LaserChannelIndex";
_code = _hash get _Channel;
_heli setVariable ["ace_laser_code", _code];

//attackprofile
private _attackProfile = [_heli] call fza_fnc_HellfireGetAttackProfile;
_heli setVariable ["ace_missileguidance_attackProfile", _attackProfile];

/*
private _attackConfig = configFile >> "Ace_missileguidance_attackprofiles" >> "hellfire_hi";
private _configLaunchHeightClear = getNumber (_attackConfig >> "Ace_missileguidance_launchHeightClear");
_configLaunchHeightClear;