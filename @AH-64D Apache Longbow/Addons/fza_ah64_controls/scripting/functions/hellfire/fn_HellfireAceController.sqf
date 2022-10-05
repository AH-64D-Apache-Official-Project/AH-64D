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
if (_heli getVariable "fza_ah64_selectedMissile" == "fza_agm114l_wep") then {
	_heli setVariable ["ace_missileguidance_attackProfile", "hellfire_hi"];
} else {
	_heli setVariable ["ace_missileguidance_attackProfile", _attackProfile];
};