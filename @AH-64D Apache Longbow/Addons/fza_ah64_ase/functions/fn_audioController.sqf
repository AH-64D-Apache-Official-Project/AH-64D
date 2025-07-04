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
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli", "_audioList"];

private _dcBusOn   = _heli getVariable "fza_systems_dcBusOn";
private _rlwrPower = _heli getVariable "fza_ah64_ase_rlwrPwr";
[] params [["_searching", []], ["_acquisition", []], ["_tracking", []], ["_designating", []],["_priority",0]];
_heli getVariable "fza_ah64_ase_data" params ["_Searchlist","_acquireList","_tracklist","_designatinglist"];

if (_rlwrPower == ASE_IRJAM_STATE_OFF || !_dcBusOn) exitWith {
    _heli setVariable ["fza_ah64_ase_data", [[],[],[],[]]];
};

{
    _x params ["_object", "_state","_soundclass","_objectpos"];
    switch (_state) do {
        case "searching": {
            _searching pushback _object;
            if (_object in (_designatinglist+_tracklist+_acquireList+_Searchlist)) then {continue;};
            _priority = ASE_SRH;
        };
        case "acquisition": {
            _acquisition pushback _object;
            if (_object in (_designatinglist+_tracklist+_acquireList)) then {continue;};
            _priority = ASE_ACQ;
        };
        case "tracking": {
            _tracking pushback _object;
            if (_object in (_designatinglist+_tracklist)) then {continue;};
            _object confirmSensorTarget [playerSide, true];
            _priority = ASE_TRK;
        };
        case "designating": {
            _designating pushback _object;
            if (_object in _designatinglist) then {continue;};
            _priority = ASE_LSR;
            _theta = _bearing;
        };
    };
    if !(isnil "_objectpos") then {_object = _objectpos;};
    private _theta = _heli getRelDir _object;
    private _clock = [_theta] call fza_ase_fnc_bearingClock;
    
    private _identity = format ["fza_ah64_bt_%1", _soundclass];
    private _dirAud = format ["fza_ah64_bt_%1oclock", _clock];
    private _stateAudio = format ["fza_ah64_%1", _state];

    //Play audio
    [_heli, _priority, _object, _identity, 0.8, _dirAud, 0.6, _stateAudio, 0.7] call fza_audio_fnc_addASEMessage;

    //ASE AUTOPAGE
    Private _mpdLeft  = [_heli, 0] call fza_mpd_fnc_currentPage;
    Private _mpdright = [_heli, 1] call fza_mpd_fnc_currentPage;
    if (_mpdLeft != "ase" && _mpdRight != "ase") then {
        switch (_heli getVariable "fza_ah64_ase_autopage") do {
            case ASE_AUTOPAGE_SRH: {
                if ("searching" in _state) then {
                    [_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
                };
            };
            case ASE_AUTOPAGE_ACQ: {
                if ("acquisition" in _state) then {
                    [_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
                };
            };
            case ASE_AUTOPAGE_TRK: {
                if ("tracking" in _state) then {
                    [_heli, 1, "ase"] call fza_mpd_fnc_setCurrentPage;
                };
            };
        };
    };
} foreach _audioList;

_heli setVariable ["fza_ah64_ase_data", [_searching,_acquisition,_tracking,_designating]];