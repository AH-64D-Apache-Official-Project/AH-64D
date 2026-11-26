/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rwr

Description:
    Proccessor function for the RADAR WARNING RECIEVER

Parameters:
    heli: Object - Vehicle the event handler is assigned to

Returns:
    _rwrObjects - [state, objectPos, "_iconClass", ghosted, source, bold]
    _rwrAudio   - [object, "state", "_soundclass"];

Examples:
    [_heli] call fza_ase_fnc_rwr

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli"];

[] params [["_rwrObjects",[]],["_rwrCount",0],["_rwrAudio",[]],["_launching",[]]];
private _threats = getSensorThreats _heli;

{
    _x params ["_object", "_type", "_sensor"];

    private _object = vehicle _object;
    if (_object in _launching) then {continue;};
    switch (_type) do {
        case "missile": {
            private _launcher = (getShotParents _object) param [0, objNull];
            private _seekerhead = getNumber (configOf _object >> "weaponLockSystem");
            if (!isNull _launcher && {[_seekerhead, 8] call BIS_fnc_bitwiseAND == 8}) then {
                _launching pushBack _launcher;
                private _launcherIndex = _rwrObjects findIf {(_x # 1) isEqualTo _launcher};
                if (_launcherIndex >= 0) then {_rwrObjects deleteAt _launcherIndex;};
                _launcherIndex = _rwrAudio findIf {(_x # 0) isEqualTo _launcher};
                if (_launcherIndex >= 0) then {_rwrAudio deleteAt _launcherIndex;};
                [_heli, _launcher, ASE_LNC] call fza_ase_fnc_classification params ["_soundclass","_iconClass"];
                _rwrObjects pushBack [ASE_LNC, _object, _iconClass, false, _launcher];
                continue;
            };
        };
        case "locked": {
            [_heli, _object, ASE_TRK] call fza_ase_fnc_classification params ["_soundclass","_iconClass"];
            _rwrObjects pushBack [ASE_TRK, _object, _iconClass, false, _object];
            _rwrAudio pushBack [_object, "tracking", _soundclass];
            continue;
        };
        case "marked": {
            [_heli, _object, ASE_ACQ] call fza_ase_fnc_classification params ["_soundclass","_iconClass"];
            _rwrObjects pushBack [ASE_ACQ, _object, _iconClass, false, _object];
            _rwrAudio pushBack [_object, "acquisition", _soundclass];
        };
    };
} forEach _threats;

private _threatObjects = _threats apply {vehicle (_x # 0)};
{
    _x params ["_object", "_type", "_relationship", "_sensor"];
    private _object = vehicle _object;
    if (_object in _launching) then {continue;};
    if (_object in _threatObjects) then {continue;};
    if ("passiveradar" in _sensor) then {
        [_heli, _object] call fza_ase_fnc_classification params ["_soundclass","_iconClass"];
        _rwrObjects pushBack [ASE_SRH, getPos _object, _iconClass, false, _object];
        _rwrAudio pushBack [_object, "searching", _soundclass];
    };
} forEach getSensorTargets _heli;

// No longer detected: ghosted where it was last seen, at the last state it was shown at, until ASE_RLWR_DROP_TIME. Its
// audio entry is kept so that coming back meanwhile isn't announced as a new threat; a higher mode still is. A missile
// is shown only while it is detected: its launcher isn't ghosted while it is in flight or after. A threat is new, and
// bold for ASE_RLWR_BOLD_TIME, when first detected, not when it comes back while ghosted.
// Last seen, by hashValue: [source, state, iconClass, pos, seen at, audio entry, first seen]
private _now   = CBA_missionTime;
private _audio = createHashMap;
{_audio set [hashValue (_x # 0), _x];} forEach _rwrAudio;
private _prevLast = _heli getVariable ["fza_ah64_ase_rlwrLast", createHashMap];
if !(_prevLast isEqualType createHashMap) then {_prevLast = createHashMap;};
private _last = createHashMap;
{
    _x params ["_state", "", "_iconClass", "", "_source"];
    if (isNull _source || {_state >= ASE_LNC}) then {continue;};
    private _key  = hashValue _source;
    private _prev = _last get _key;
    if (!isNil "_prev" && {_state <= _prev # 1}) then {continue;};
    private _firstSeen = (_prevLast getOrDefault [_key, []]) param [6, _now];
    _last set [_key, [_source, _state, _iconClass, getPos _source, _now, +(_audio getOrDefault [_key, []]), _firstSeen]];
} forEach _rwrObjects;
{
    _x params ["_state", "", "", "", "_source"];
    if (isNull _source || {_state >= ASE_LNC}) then {continue;};
    _x set [5, _now - ((_last getOrDefault [hashValue _source, []]) param [6, _now]) < ASE_RLWR_BOLD_TIME];
} forEach _rwrObjects;
{
    _y params ["_source", "_state", "_iconClass", "_pos", "_seenAt", ["_audioEntry", []]];
    if (isNull _source || {_x in _last}) then {continue;};
    // A launcher with a missile in flight is kept for its first seen time, but never ghosted
    if (_source in _launching) then {
        _y set [4, -1e9];
        _last set [_x, _y];
        continue;
    };
    if (_now - _seenAt > ASE_RLWR_DROP_TIME) then {continue;};
    _rwrObjects pushBack [_state, _pos, _iconClass, true, _source, false];
    if (_audioEntry isNotEqualTo []) then {_rwrAudio pushBack _audioEntry;};
    _last set [_x, _y];
} forEach _prevLast;
_heli setVariable ["fza_ah64_ase_rlwrLast", _last];

[_rwrObjects, _rwrAudio]
