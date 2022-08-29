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
private _searching     		= [];
private _aquisition     		= [];
private _tracking     		= [];
hintsilent str _audiolist;

{
    _x params ["_object", "_Radarstate"];
	//is audio currently playing
	if (fza_ah64_aseAudioPlaying == true) exitwith {};

	// Classification Audio
	_Classification = [_object] call fza_fnc_aseAdaClassification;
	private _identity = format ["fza_ah64_bt_%1", _Classification];
	If (_Classification == "radar") then {
		copyToClipboard str _object + _Radarstate;
	};

	// Direction Audio
	private _theta = [_heli, (getpos _heli select 0), (getpos _heli select 1), (getpos _object select 0), (getpos _object select 1)] call fza_fnc_relativeDirection;
	private _clock = [_theta] call fza_fnc_bearingClock;
	private _dirAud = format ["fza_ah64_bt_%1oclock", _clock];

	// State audio
	if (_Radarstate == "Searching") then {
		_searching pushback _object;
	};
	if (_Radarstate == "Aquisition") then {
		_aquisition pushback _object;
	};
	if (_Radarstate == "Tracking") then {
		_tracking pushback _object;
		_object confirmSensorTarget [playerSide, true];
	};
	private _stateAudio = format ["fza_ah64_%1", _Radarstate];

	//_ADA audio Previously played check
	private _Searchlist = _heli getVariable "fza_ah64_ase_searchingObj";
	private _aquirelist = _heli getVariable "fza_ah64_ase_AquisitionObj";
	private _tracklist = _heli getVariable "fza_ah64_ase_trackingobj";
	if (_object in _Searchlist && _Radarstate == "searching") exitwith {};
	if ((_object in _Searchlist &&  _object in _aquirelist) && !(_Radarstate == "Tracking")) exitwith {};
	if (_object in _Searchlist && _object in _aquirelist && _object in _tracklist ) exitwith {};


	//Play audio
	fza_ah64_aseAudioPlaying = true;
	[_identity, 1, _dirAud, 1, _stateAudio, 1] spawn fza_fnc_playAudio;
	sleep 3;
	fza_ah64_aseAudioPlaying = false;
	//ASE AUTOPAGE
	if (_Autopage == 1 && _Radarstate == "Searching") then {
		[_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
	};
	if (_Autopage == 2 && _Radarstate == "Aquisition") then {
		[_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
	};
	if (_Autopage == 3 && _Radarstate == "Tracking") then {
		[_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
	};
} foreach _audioList;

_heli setVariable ["fza_ah64_ase_searchingObj", _searching];
_heli setVariable ["fza_ah64_ase_AquisitionObj", _aquisition];
_heli setVariable ["fza_ah64_ase_trackingobj", _tracking];