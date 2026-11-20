/* ----------------------------------------------------------------------------
Function: fza_ase_fnc_rwr

Description:
    Proccessor function for the RADAR WARNING RECIEVER

Parameters:
    heli: Object - Vehicle the event handler is assigned to

Returns:
    _rwrObjects - [state, objectPos, "_iconClass"]
    _rwrAudio   - [object, "state", "_soundclass"];

Examples:
    [_heli] call fza_ase_fnc_rwr

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
#include "\fza_ah64_ase\headers\ase.h"
params ["_heli"];

[] params [["_rwrObjects",[]],["_rwrCount",0],["_rwrAudio",[]],["_launching",[]]];

{
    _x params ["_object", "_type", "_sensor"];

    private _object = vehicle _object;
    if (_object in _launching) then {continue;};
    switch (_type) do {
        case "missile": {
            private _launcher = (getShotParents _object)#0;
            private _seekerhead = getNumber (configOf _object >> "weaponLockSystem");
            if ([_seekerhead, 8] call BIS_fnc_bitwiseAND == 8) then {
                _launching pushBack _launcher;
                private _launcherIndex = _rwrObjects findIf {(_x # 1) isEqualTo _launcher};
                if (_launcherIndex >= 0) then {_rwrObjects deleteAt _launcherIndex;};
                _launcherIndex = _rwrAudio findIf {(_x # 0) isEqualTo _launcher};
                if (_launcherIndex >= 0) then {_rwrAudio deleteAt _launcherIndex;};
                [_heli, _launcher, ASE_LNC] call fza_ase_fnc_classification params ["_soundclass","_iconClass"];
                _rwrObjects pushBack [ASE_LNC, _object, _iconClass];
                continue;
            };
        };
        case "locked": {
            [_heli, _object] call fza_ase_fnc_classification params ["_soundclass","_iconClass"];
            _rwrObjects pushBack [ASE_TRK, _object, _iconClass];
            _rwrAudio pushBack [_object, "tracking", _soundclass];
            continue;
        };
        case "marked": {
            [_heli, _object] call fza_ase_fnc_classification params ["_soundclass","_iconClass"];
            _rwrObjects pushBack [ASE_ACQ, _object, _iconClass];
            _rwrAudio pushBack [_object, "acquisition", _soundclass];
        };
    };
} forEach getSensorThreats _heli;

private _threatObjects = getSensorThreats _heli apply {vehicle (_x # 0)};
{
    _x params ["_object", "_type", "_relationship", "_sensor"];
    private _object = vehicle _object;
    if (_object in _launching) then {continue;};
    if (_object in _threatObjects) then {continue;};
    if ("passiveradar" in _sensor) then {
        [_heli, _object] call fza_ase_fnc_classification params ["_soundclass","_iconClass"];
        _rwrObjects pushBack [ASE_SRH, getPos _object, _iconClass];
        _rwrAudio pushBack [_object, "searching", _soundclass];
    };
} forEach getSensorTargets _heli;

// Radars the radar jammer knocked off the air are held at the highest state they were shown at until the hold runs
// out, so their return isn't announced as a new threat
private _held = (_heli getVariable ["fza_ah64_ase_rJamHeld", []]) select {_x # 1 > CBA_missionTime && {alive (_x # 0)}};
if (_held isNotEqualTo []) then {
    _heli getVariable ["fza_ah64_ase_data", []] params [["_srhList", []], ["_acqList", []], ["_trkList", []]];
    private _states = ["searching", "acquisition", "tracking"];
    {
        private _object = _x # 0;
        if (_object in _launching) then {continue;};
        private _prev = [_trkList, _acqList, _srhList] findIf {_object in _x};
        if (_prev < 0) then {continue;};
        _prev = ASE_TRK - _prev;
        private _cur = -1;
        {
            if (_x # 0 isEqualTo _object) then {_cur = _cur max (_states find (_x # 1));};
        } forEach _rwrAudio;
        if (_cur >= _prev) then {continue;};

        private _pos = getPos _object;
        _rwrObjects = _rwrObjects select {!((_x # 1) isEqualTo _object || {(_x # 1) isEqualTo _pos})};
        _rwrAudio   = _rwrAudio select {(_x # 0) isNotEqualTo _object};
        [_heli, _object] call fza_ase_fnc_classification params ["_soundclass", "_iconClass"];
        _rwrObjects pushBack [_prev, [_object, _pos] select (_prev == ASE_SRH), _iconClass];
        _rwrAudio pushBack [_object, _states # _prev, _soundclass];
    } forEach _held;
};

_rwrObjects = [_rwrObjects, [], {_x # 0}, "DESCEND"] call BIS_fnc_sortBy;

[_rwrObjects, _rwrAudio]
