/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rJamStatic

Description:
    Every frame while radio jamming static is on (fza_ase_fnc_rJamComms). The static is one
    looping sound on a sound source made on this machine only and attached to the player's
    vehicle, or to the player on foot. Its volume, the jam's strength times the loudest radio
    that is on, is set through CustomSoundController1 and moves to each new value over one
    radio jamming check. It is raised by what the listener's vehicle muffles outside sounds
    by (fza_ase_fnc_rJamStaticMakeUp). Back at silence the source is deleted and this stops.
    It fades to silence by itself if the checks stop telling it what to play, and they clear
    it if it stops being played.

Parameters:
    CBA per frame handler arguments

Returns:
    Nothing

Examples:
    [{_this call fza_ase_fnc_rJamStatic}, 0] call CBA_fnc_addPerFrameHandler

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["", "_handle"];

// Silent once the radio jamming checks stop saying what to play (fza_ase_fnc_rJamComms)
fza_ase_commsStaticTarget params [["_strength", 0, [0]], ["_radio", 0, [0]], ["_at", -1e9, [0]]];
private _target = [0, ASE_RJAM_COMMS_GAIN * _strength * _radio] select (CBA_missionTime - _at < 1);
fza_ase_commsStatic params [["_source", objNull], ["_volume", 0], ["_to", 0], ["_rate", 0], ["_played", -1]];

if (_target != _to) then {
    _to   = _target;
    _rate = abs (_target - _volume) / ASE_RJAM_COMMS_INTERVAL;
};
_volume = [(_volume + _rate * diag_deltaTime) min _to, (_volume - _rate * diag_deltaTime) max _to] select (_to < _volume);

if (_volume <= 0 && {_to <= 0}) exitWith {
    deleteVehicle _source;
    fza_ase_commsStatic       = [];
    fza_ase_commsStaticHandle = nil;
    [_handle] call CBA_fnc_removePerFrameHandler;
};

// Raised by what the listener's vehicle muffles, worked out again only when where they listen from changes
private _unit   = call CBA_fnc_currentUnit;
private _parent = vehicle _unit;
private _seat   = [_parent, cameraView, isTurnedOut _unit, _parent unitTurret _unit, _parent getCargoIndex _unit, isNull curatorCamera];
if (_seat isNotEqualTo fza_ase_commsStaticSeat) then {
    fza_ase_commsStaticSeat   = _seat;
    fza_ase_commsStaticMakeUp = [_unit] call fza_ase_fnc_rJamStaticMakeUp;
};

if (isNull _source) then {
    _source = "fza_ah64_rJamStatic" createVehicleLocal [0, 0, 0];
    _played = -1;
};
if (!isNull _parent && {attachedTo _source isNotEqualTo _parent}) then {
    _source attachTo [_parent, [0, 0, 0]];
};
private _level = _volume * fza_ase_commsStaticMakeUp;
if (_level != _played) then {
    _played = _level;
    setCustomSoundController [_source, "CustomSoundController1", _level];
};
fza_ase_commsStatic     = [_source, _volume, _to, _rate, _played];
// Still being played, for the radio jamming checks to see
fza_ase_commsStaticBeat = CBA_missionTime;
