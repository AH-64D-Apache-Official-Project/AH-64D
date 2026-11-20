/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rJamStatic

Description:
    Every frame while radio jamming static plays (fza_ase_fnc_rJamComms): its level eases to
    the target, and the loop is started again on each small change, as a playing sound's
    volume can't be changed, at most 10 times a second, with a random variant each time.
    Ends once faded out.

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

fza_ase_commsStatic params [["_id", -1], ["_end", 0], ["_played", 0], ["_level", 0], ["_at", diag_tickTime], ["_startedAt", -1]];
private _target = fza_ase_commsStaticTarget;
_level = _level + (_target - _level) * (1 min ((diag_tickTime - _at) * 8));

if (_target <= 0 && {_level < 0.01}) exitWith {
    if (_id >= 0) then {stopSound _id;};
    fza_ase_commsStatic       = [];
    fza_ase_commsStaticHandle = nil;
    [_handle] call CBA_fnc_removePerFrameHandler;
};

if (_id < 0 || {diag_tickTime >= _end} || {abs (_level - _played) > 0.04 && {diag_tickTime - _startedAt >= 0.1}}) then {
    if (_id >= 0) then {stopSound _id;};
    // A different variant each time, so a run of quick restarts doesn't repeat the same start
    _id = playSoundUI [format ["fza_ah64_rJamStatic%1", 1 + floor random ASE_RJAM_COMMS_STATICS], _level * ASE_RJAM_COMMS_GAIN, 1, true];
    if (isNil "_id") then {_id = -1;};
    private _length = if (_id >= 0) then {(soundParams _id) param [2, 0]} else {0};
    if (_length < 1) then {_length = 3;};
    _end       = diag_tickTime + _length - 0.05;
    _played    = _level;
    _startedAt = diag_tickTime;
    if (missionNamespace getVariable ["fza_ase_rJamDebug", false]) then {
        diag_log format ["fza_ase_rJam static: id %1, volume %2, target %3, params %4", _id, _level * ASE_RJAM_COMMS_GAIN, _target, soundParams _id];
    };
};
fza_ase_commsStatic = [_id, _end, _played, _level, diag_tickTime, _startedAt];
