/* ----------------------------------------------------------------------------
Function: fza_fnc_aseRLWR

Description:
    Handles RLWR logic

Parameters:
    _heli - The helicopter the RLWR is on

Returns:
	nothing

Examples:
	_this spawn fza_fnc_aseRLWR;
    
Author:
	BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\mpd_defines.hpp"
#include "\fza_ah64_controls\headers\systemConstants.h"

params ["_heli"];

private _aseObjs = [];
//Sensor targets - Lasers, Search
{
	_x params ["_target", "_type", "_relationship", "_sensor"];
	private _distance_m = _heli distance2d _target;
	//Lasers
	if ("laser" in _sensor) then {
		if (_distance_m <= ASE_LSR_RANGE_M) then {
			_aseObjs pushBack [ASE_LSR, _heli getRelDir _target];
		};
	};
	//Search
	if ("passiveradar" in _sensor) then {
		if (_distance_m <= ASE_SRH_RANGE_M) then {
			_aseObjs pushBack [ASE_SRH, _heli getRelDir _target];
		};
	};
} foreach getSensorTargets _heli;

//Sensor threats - Acquisition, Track and Launch
{
	_x params ["_object", "_type", "_sensor"];
	private _distance_m = _heli distance2d _object;
	//Acquisition
	if ("marked" in _type) then {
		if (_distance_m <= ASE_ACQ_RANGE_M) then {
			_aseObjs pushBack [ASE_ACQ, _heli getRelDir _object];
		};
	};
	//Track
	if ("locked" in _type) then {
		if (_distance_m <= ASE_TRK_RANGE_M) then {
			_aseObjs pushBack [ASE_TRK, _heli getRelDir _object];
		};
	};
	//Launch
	//Rhea Missile only currently
	if (["missile_sam_04_fly_f.p3d", str _object] call BIS_fnc_inString) then {
		if (_distance_m <= ASE_LNC_RANGE_M) then {
			_aseObjs pushBack [ASE_LNC, _heli getRelDir _object];
		};
	};
} foreach getSensorThreats _heli;

_aseObjs = [_aseObjs, [], {_x # 0}, "DESCEND"] call BIS_fnc_sortBy;

for "_i" from 0 to 6 do {
	if (_i >= count _aseObjs) then {
		_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_OBJECT_01_MD + _i), -1];
		_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_OBJECT_01_AZ + _i), -1];
	} else {
		(_aseObjs select _i) params ["_mode", "_azimuth"];
		_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_OBJECT_01_MD + _i), _mode];
		_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_OBJECT_01_AZ + _i), _azimuth];
	};
};

//Test
hintsilent format ["Ase Objs = %1", _aseObjs];