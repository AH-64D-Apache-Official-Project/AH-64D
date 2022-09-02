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
private _aquirelist 		= _heli getVariable "fza_ah64_ase_AquisitionObj";
private _tracklist 			= _heli getVariable "fza_ah64_ase_trackingobj";
private _searching     		= [];
private _aquisition     	= [];
private _tracking     		= [];

{
	if (fza_ah64_aseAudioPlaying == false) then {
		_x params ["_object", "_Radarstate"];

		// Classification Audio
		_Classification = [_object] call fza_fnc_aseAdaClassification;
		private _identity = format ["fza_ah64_bt_%1", _Classification];

		// Direction Audio
		private _theta = [_heli, (getpos _heli select 0), (getpos _heli select 1), (getpos _object select 0), (getpos _object select 1)] call fza_fnc_relativeDirection;
		private _clock = [_theta] call fza_fnc_bearingClock;
		private _dirAud = format ["fza_ah64_bt_%1oclock", _clock];

		// State audio
		if (_Radarstate == "Searching") then {
			_searching pushback _object;
			_heli setVariable ["fza_ah64_ase_searchingObj", _searching];
		};
		if (_Radarstate == "Aquisition") then {
			_aquisition pushback _object;
			_heli setVariable ["fza_ah64_ase_AquisitionObj", _aquisition];
		};
		if (_Radarstate == "Tracking") then {
			_tracking pushback _object;
			_object confirmSensorTarget [playerSide, true];
			_heli setVariable ["fza_ah64_ase_trackingobj", _tracking];
		};
		private _stateAudio = format ["fza_ah64_%1", _Radarstate];

		//_ADA audio Previously played check
		if (_object in _Searchlist && _Radarstate == "searching") exitwith {};
		if (_object in _aquirelist && !(_Radarstate == "tracking")) exitwith {};
		if (_object in _tracklist) exitwith {};

		//Play audio
		[_identity, 0.8, _dirAud, 0.6, _stateAudio, 0.7] spawn fza_fnc_playAudio;
		private _future = time + 2.1;
		while {(time >= _future)} do {
			fza_ah64_aseAudioPlaying = true;
		};
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
	};
} foreach _audioList;

_heli setVariable ["fza_ah64_ase_searchingObj", _searching];
_heli setVariable ["fza_ah64_ase_AquisitionObj", _aquisition];
_heli setVariable ["fza_ah64_ase_trackingobj", _tracking];