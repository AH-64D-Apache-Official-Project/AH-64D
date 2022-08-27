/* ----------------------------------------------------------------------------
Function: fza_fnc_aseAudioController

Description:
	Handles ASE audio

Parameters:
	heli: Object - Vehicle the event handler is assigned to

Returns:
	Nothing

Examples:
    [_heli,_object,_Radarstate] call fza_fnc_aseAudioController

Author:
	BradMick
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli","_Object","_Radarstate"];

if !(_heli getVariable "fza_ah64_apu" && (isEngineOn _heli)) exitwith {};

private _Autopage		    = _heli getVariable "fza_ah64_ase_autopage";
private _detected     		= _heli getVariable "fza_ah64_ase_detectedobj";
private _searching     		= _heli getVariable "fza_ah64_ase_searchingObj";
private _tracking     		= _heli getVariable "fza_ah64_ase_trackingobj";
private _identity           = "Radar";

// Classification Audio

if ((_Object iskindof "rhs_zsutank_base") || (_Object iskindof "CUP_ZSU23_Base")) then {_identity = "zsu23"};
if (_Object iskindof "CUP_2S6_Base") then {_identity = "2s6"};
if ((_Object iskindof "B_APC_Tracked_01_base_F") || (_Object iskindof "O_APC_Tracked_02_base_F")) then {_identity = ""};
if ((_Object iskindof "Radar_System_01_base_F") || (_Object iskindof "Radar_System_02_base_F") || (vehicle _Object iskindof "SAM_System_03_base_F") || (vehicle _Object iskindof "SAM_System_04_base_F")) then {_identity = ""};

// Direction Audio
private _theta = [_heli, (getpos _heli select 0), (getpos _heli select 1), (_object select 0), (_object select 1)] call fza_fnc_relativeDirection;
private _clock = [_theta] call fza_fnc_bearingClock;
private _dirAud = format ["fza_ah64_bt_%1oclock", _clock];

// State audio
if (_Radarstate == "passiveradar") then {_Radarstate = "Searching";};
if (_Radarstate == "marked") then {_Radarstate = "Aquisition";};
if (_Radarstate == "locked") then {_Radarstate = "Tracking";};
private _stateAudio = format ["fza_ah64_bt_%1oclock", _State];


if ((fza_ah64_aseAudioPlaying == false)) then {
	fza_ah64_aseAudioPlaying = true
	[_identity, 1, _dirAud, 1, _stateAudio, 1] call fza_fnc_playAudio;
	sleep 3;
	fza_ah64_aseAudioPlaying = false;
};

if (_state == "locked") then {
	_object confirmSensorTarget [playerSide, true];
};

//ASE AUTOPAGE
if (_Autopage == ASE_AUTOPAGE_SRH && _Radarstate == "Searching") then {
	[_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
};
if (_Autopage == ASE_AUTOPAGE_ACQ && _Radarstate == "Aquisition") then {
	[_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
};
if (_Autopage == ASE_AUTOPAGE_TRK && _Radarstate == "Tracking") then {
	[_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
};