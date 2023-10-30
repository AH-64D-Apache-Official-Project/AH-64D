/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_audioController

Description:
    Handles ASE audio

Parameters:
    heli: Object - Vehicle the event handler is assigned to
    _audioList: array - filled with vehicles and radar states

Returns:
    Nothing

Examples:
    [_heli, _audioList] call fza_ase_fnc_audioController

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_controls\headers\systemConstants.h"
params ["_heli"];

private _dcBusOn            = _heli getVariable "fza_systems_dcBusOn";
private _audioList          = _heli getVariable "fza_ah64_ase_audioList";
private _Autopage           = _heli getVariable "fza_ah64_ase_autopage";
private _rlwrPower          = _heli getVariable "fza_ah64_ase_rlwrPwr";
private _Searchlist         = _heli getVariable "fza_ah64_ase_searchingObj";
private _acquireList        = _heli getVariable "fza_ah64_ase_acquisitionObj";
private _tracklist          = _heli getVariable "fza_ah64_ase_trackingobj";
Private _mpdLeft            = [_heli, 0] call fza_mpd_fnc_currentPage;
Private _mpdright           = [_heli, 1] call fza_mpd_fnc_currentPage;
private _searching          = [];
private _acquisition        = [];
private _tracking           = [];
private _priority           = 0;

if (_rlwrPower == "OFF" || !_dcBusOn) exitWith {
    _heli setVariable ["fza_ah64_ase_searchingObj", _searching];
    _heli setVariable ["fza_ah64_ase_acquisitionObj", _acquisition];
    _heli setVariable ["fza_ah64_ase_trackingobj", _tracking];
};
{
    _x params ["_object", "_radarState"];

    // Classification Audio
    _classification = [_object] call fza_ase_fnc_adaClassification;
    private _identity = format ["fza_ah64_bt_%1", _classification];

    // Direction Audio
    private _theta = [_heli, (getpos _heli select 0), (getpos _heli select 1), (getpos _object select 0), (getpos _object select 1)] call fza_fnc_relativeDirection;
    private _clock = [_theta] call fza_fnc_bearingClock;
    private _dirAud = format ["fza_ah64_bt_%1oclock", _clock];

    // State audio
    if (_radarState == "searching") then {
        _searching pushback _object;
        _heli setVariable ["fza_ah64_ase_searchingObj", _searching];
        _priority = ASE_SRH;
    };
    if (_radarState == "acquisition") then {
        _acquisition pushback _object;
        _heli setVariable ["fza_ah64_ase_acquisitionObj", _acquisition];
        _priority = ASE_ACQ;
    };
    if (_radarState == "tracking") then {
        _tracking pushback _object;
        _object confirmSensorTarget [playerSide, true];
        _heli setVariable ["fza_ah64_ase_trackingobj", _tracking];
        _priority = ASE_TRK;
    };
    private _stateAudio = format ["fza_ah64_%1", _radarState];

    //_ADA audio Previously played check
    if (_object in _Searchlist && _radarState == "searching") then {continue;};
    if (_object in _acquireList && !(_radarState == "tracking")) then {continue;};
    if (_object in _tracklist) then {continue;};

    //Play audio
    [_heli, _priority, _object, _identity, 0.8, _dirAud, 0.6, _stateAudio, 0.7] call fza_audio_fnc_addASEMessage;

    //ASE AUTOPAGE
    if !(_mpdLeft == "ase" || _mpdRight == "ase") then {
        if (_Autopage == 1 && _radarState == "searching") then {
            [_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
        };
        if (_Autopage == 2 && _radarState == "acquisition") then {
            [_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
        };
        if (_Autopage == 3 && _radarState == "tracking") then {
            [_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
        };
    };
} foreach _audioList;

_heli setVariable ["fza_ah64_ase_searchingObj", _searching];
_heli setVariable ["fza_ah64_ase_acquisitionObj", _acquisition];
_heli setVariable ["fza_ah64_ase_trackingobj", _tracking];