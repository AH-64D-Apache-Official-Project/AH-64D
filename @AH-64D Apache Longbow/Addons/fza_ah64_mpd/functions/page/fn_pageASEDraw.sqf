#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"
params ["_heli", "_mpdIndex"];

private _lsrRange_m = 4000;		//Laser

private _srhRange_m = 10000;	//Search
private _acqRange_m = 8000;		//Acquisition
private _trkRange_m = 6000;		//Track
private _lncRange_m = 4000;		//Launch

private _lasers   = [];
private _srhRadar = [];
private _acqRadar = [];
private _trkRadar = [];
private _lncRadar = [];

private _threatAz = [];

//Need a threat object which contains type (lsr, srh, acq, trk, lnc) and azimuth

{
	_x params ["_target", "_type", "_relationship", "_sensor"];
	private _distance_m = _heli distance2d _target;
	//Lasers
	if ("laser" in _sensor) then {
		if (_distance_m <= _lsrRange_m) then {
			_lasers pushBack _target;
			_threatAz pushBack (_heli getRelDir _target);
		};
	};
	//Search
	if ("passiveradar" in _sensor) then {
		if (_distance_m <= _srhRange_m) then {
			_srhRadar pushBack _target;
			_threatAz pushBack (_heli getRelDir _target);
		};
	};
} foreach getSensorTargets _heli;

{
	_x params ["_object", "_type", "_sensor"];
	private _distance_m = _heli distance2d _object;
	//Acquisition
	if ("marked" in _type) then {
		if (_distance_m <= _acqRange_m) then {
			_acqRadar pushBack _object;
			_threatAz pushBack (_heli getRelDir _object);
		};
	};
	//Track
	if ("locked" in _type) then {
		if (_distance_m <= _trkRange_m) then {
			_trkRadar pushBack _object;
			_threatAz pushBack (_heli getRelDir _object);
		};
	};
	//Launch
	//Rhea Missile only currently
	if (["missile_sam_04_fly_f.p3d", str _object] call BIS_fnc_inString) then {
		if (_distance_m <= _lncRange_m) then {
			_lncRadar pushBack _object;
			_threatAz pushBack (_heli getRelDir _object);
		};
	};
} foreach getSensorThreats _heli;


_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_ASE_ICON_01_AZ), 90];



//Test
hintsilent format ["Lasers = %1
					\nSearch Radars = %2
					\nAcquisition Radars = %3
					\nTrack Radars = %4
					\nLaunch Radars = %5
					\nThreat Az = %6", _lasers, _srhRadar, _acqRadar, _trkRadar, _lncRadar, _threatAz];