/* ----------------------------------------------------------------------------
Function: fza_fnc_setAceLaserDes

Description:
	Used to set the ace laer to the Primary lrfd code

Parameters:
    _heli - the helicopter

Returns:
	Nothing

Examples:
	[_heli] call fza_fnc_setAceLaserDes;

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
params ["_heli"];

//Grab LRFD code
private _LRFD_CODE = (_heli getvariable "fza_ah64_PrimaryAlternateChannels") # 0;

//set LRFD code
_heli setVariable ["ace_laser_code", _LRFD_CODE #1, true];

/*

vehicle player setVariable ["ace_laser_code", _code, true];
vehicle player getVariable ["ace_laser_code", ACE_DEFAULT_LASER_CODE];