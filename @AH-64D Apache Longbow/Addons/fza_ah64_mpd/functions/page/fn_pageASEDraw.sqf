#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli", "_mpdIndex"];

//Chaff
private _chaffState = BOOLTONUM(_heli getVariable "fza_ah64_ase_chaffState" == "safe");
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_CHAFF_STATE), _chaffState];
private _chaffCount = 0; //<-- this is duplicated in the WPN page!!
{
	_x params ["_className", "_turretPath", "_ammoCount"];
	if (_className == "60Rnd_CMFlareMagazine" && _turretPath isEqualTo [-1]) then {
		_chaffCount = _chaffCount + _ammoCount;
	};
} forEach magazinesAllTurrets _heli;
_heli setUserMfdText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_CHAFF_QTY), _chaffCount toFixed 0];

//RLWR
private _rlwrPwr = BOOLTONUM(_heli getVariable "fza_ah64_ase_rlwrPwr" == "off");
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_RLWR_PWR), _rlwrPwr];
//private _rlwrCount  = _heli getVariable "fza_ah64_ase_rlwrCount";
_heli setUserMfdText  [MFD_INDEX_OFFSET(MFD_TEXT_IND_ASE_RLWR_COUNT), "##"];

//IR Jammer
private _irJamPwr = BOOLTONUM(_heli getVariable "fza_ah64_ase_irjamPwr" == "off");
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_IRJAM_PWR), _irJamPwr];
//private _rlwrCount  = _heli getVariable "fza_ah64_ase_rlwrCount";
_heli setUserMfdValue  [MFD_INDEX_OFFSET(MFD_IND_ASE_IRJAM_STATE), ASE_IRJAM_STATE_OPER];

//RF Jammer
private _rfJamState = _heli getVariable "fza_ah64_ase_rfJamState";
systemChat format ["RF Jam State = %1", _rfJamState];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_RFJAM_STATE), _rfJamState];

//Autopage
private _autopage = _heli getVariable "fza_ah64_ase_autopage";
systemChat format ["Autopage State = %1", _autopage];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_AUTOPAGE), _autopage];






//This needs to go to controls\ASE
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
