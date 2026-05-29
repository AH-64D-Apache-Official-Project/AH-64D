params [
    ["_scope", "own", [""]],
    ["_name", "", [""]],
    ["_stateJson", "", [""]]
];

private _trimmedName = trim _name;
if (_trimmedName isEqualTo "") exitWith {false};
if (_stateJson isEqualTo "") exitWith {false};

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
        private _entryName = _entry # 0;
        if ((toLower str _entryName) isEqualTo (toLower _trimmedName)) exitWith {
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
};

true;
