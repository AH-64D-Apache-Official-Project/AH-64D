params [
    ["_scope", "own", [""]],
    ["_name", "", [""]],
    ["_stateJson", "", [""]]
];

private _trimmedName = trim _name;
diag_log format ["[MP saveConfig] called scope=%1 name=%2 stateJsonLen=%3", _scope, _trimmedName, count _stateJson];
if (_trimmedName isEqualTo "") exitWith {
    diag_log "[MP saveConfig] EXIT: empty name";
    false
};
if (_stateJson isEqualTo "") exitWith {
    diag_log "[MP saveConfig] EXIT: empty stateJson";
    false
};

private _isMissionScope = toLower _scope isEqualTo "mission";
private _key = ["fza_mplanner_saves_own", "fza_mplanner_saves_mission"] select _isMissionScope;
private _namespace = [profileNamespace, missionNamespace] select _isMissionScope;
private _ownerUid = getPlayerUID player;
private _ownerName = name player;

private _entries = +(_namespace getVariable [_key, []]);
if !(_entries isEqualType []) then {
    _entries = [];
};

private _idx = -1;
for "_i" from 0 to ((count _entries) - 1) do {
    private _entry = _entries # _i;
    if (_entry isEqualType [] && {(count _entry) >= 1}) then {
        private _entryName = _entry param [0, "", [""]];
        if ((toLower _entryName) isEqualTo (toLower _trimmedName)) exitWith {
            _idx = _i;
        };
    };
};

private _newEntry = [_trimmedName, _stateJson, diag_tickTime, _ownerUid, _ownerName];
if (_idx >= 0) then {
    _entries set [_idx, _newEntry];
} else {
    _entries pushBack _newEntry;
};

_namespace setVariable [_key, _entries];
if (!_isMissionScope) then {
    saveProfileNamespace;
    diag_log format ["[MP saveConfig] OK: saved '%1' to scope=%2, %3 total entries", _trimmedName, _scope, count _entries];
    systemChat format ["Mission Planner: saved '%1' to profile (%2 total saves).", _trimmedName, count _entries];
} else {
    diag_log format ["[MP saveConfig] OK: saved '%1' to mission scope, %2 total entries", _trimmedName, count _entries];
    systemChat format ["Mission Planner: saved '%1' to mission namespace.", _trimmedName];
};

true;
