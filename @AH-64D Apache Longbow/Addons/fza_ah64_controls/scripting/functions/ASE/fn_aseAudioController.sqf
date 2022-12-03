/* ----------------------------------------------------------------------------
Function: fza_fnc_aseAudioController

Description:
	Handles ASE audio

Parameters:
	heli: Object - Vehicle the event handler is assigned to
	_audioList: array - filled with vehicles and radar states

Returns:
	Nothing

Examples:
    [_heli, _audioList] call fza_fnc_aseAudioController

Author:
	Rosd6(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli","_audioList"];

if !(isEngineOn _heli) exitwith {};

private _Autopage		    = _heli getVariable "fza_ah64_ase_autopage";
private _Searchlist 		= _heli getVariable "fza_ah64_ase_searchingObj";
private _aquirelist 		= _heli getVariable "fza_ah64_ase_AcquisitionObj";
private _tracklist 			= _heli getVariable "fza_ah64_ase_trackingobj";
private _searching     		= [];
private _Acquisition     	= [];
private _tracking     		= [];
private _priority           = 0;
hintsilent str _audioList;

{
	_x params ["_object", "_radarState"];

	// Classification Audio
	_classification = [_object] call fza_fnc_aseAdaClassification;
	private _identity = format ["fza_ah64_bt_%1", _classification];

	// Direction Audio
	private _theta = [_heli, (getpos _heli select 0), (getpos _heli select 1), (getpos _object select 0), (getpos _object select 1)] call fza_fnc_relativeDirection;
	private _clock = [_theta] call fza_fnc_bearingClock;
	private _dirAud = format ["fza_ah64_bt_%1oclock", _clock];

	// State audio
	if (_radarState == "Searching") then {
		_searching pushback _object;
		_heli setVariable ["fza_ah64_ase_searchingObj", _searching];
		_priority = 4;
	};
	if (_radarState == "Acquisition") then {
		_Acquisition pushback _object;
		_heli setVariable ["fza_ah64_ase_AcquisitionObj", _Acquisition];
		_priority = 5;
	};
	if (_radarState == "Tracking") then {
		_tracking pushback _object;
		_object confirmSensorTarget [playerSide, true];
		_heli setVariable ["fza_ah64_ase_trackingobj", _tracking];
		_priority = 6;
	};
	private _stateAudio = format ["fza_ah64_%1", _radarState];

	//_ADA audio Previously played check
	if (_object in _Searchlist && _radarState == "searching") then {continue;};
	if (_object in _aquirelist && !(_radarState == "tracking")) then {continue;};
	if (_object in _tracklist) then {continue;};

	//Play audio
	[_heli, _priority, _object, _identity, 0.8, _dirAud, 0.6, _stateAudio, 0.7] call fza_fnc_addQueuedAudio;

	//ASE AUTOPAGE
	if (_Autopage == 1 && _radarState == "Searching") then {
		[_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
	};
	if (_Autopage == 2 && _radarState == "Acquisition") then {
		[_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
	};
	if (_Autopage == 3 && _radarState == "Tracking") then {
		[_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
	};
} foreach _audioList;

_heli setVariable ["fza_ah64_ase_searchingObj", _searching];
_heli setVariable ["fza_ah64_ase_AcquisitionObj", _Acquisition];
_heli setVariable ["fza_ah64_ase_trackingobj", _tracking];