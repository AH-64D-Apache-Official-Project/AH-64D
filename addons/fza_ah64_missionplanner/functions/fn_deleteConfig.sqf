params [
    ["_scope", "own", [""]],
    ["_name", "", [""]]
];

private _trimmedName = trim _name;
diag_log format ["[MP deleteConfig] called scope=%1 name=%2 trimmed=%3", _scope, _name, _trimmedName];
if (_trimmedName isEqualTo "") exitWith {
    diag_log "[MP deleteConfig] EXIT: empty name";
    false
};

private _isMissionScope = toLower _scope isEqualTo "mission";
private _key = ["fza_mplanner_saves_own", "fza_mplanner_saves_mission"] select _isMissionScope;
private _namespace = [profileNamespace, missionNamespace] select _isMissionScope;
private _playerUid = getPlayerUID player;

private _entries = +(_namespace getVariable [_key, []]);
if !(_entries isEqualType []) exitWith {false};

// Debug: log first 5 entry names so we can see what's stored
private _dbgNames = [];
{
    if (_x isEqualType [] && {count _x >= 1}) then {
        _dbgNames pushBack (str (_x # 0));
    } else {
        _dbgNames pushBack format ["<not-array: %1>", typeName _x];
    };
    if (count _dbgNames >= 5) exitWith {};
} forEach _entries;
diag_log format ["[MP deleteConfig] searching %1 entries, first5names=%2", count _entries, _dbgNames];

private _nextEntries = [];
private _deleted = false;

{
    private _entry = _x;
    if !(_entry isEqualType []) then {
        _nextEntries pushBack _entry;
    } else {
        if ((count _entry) < 1) then {
            _nextEntries pushBack _entry;
        } else {
            private _entryName = _entry param [0, "", [""]];
            if ((toLower _entryName) isEqualTo (toLower _trimmedName) && !_deleted) then {
                private _ownerUid = if ((count _entry) > 3) then {str (_entry # 3)} else {""};
                private _ownerName = if ((count _entry) > 4) then {str (_entry # 4)} else {"the owner"};
                if (_isMissionScope && {_ownerUid != ""} && {_ownerUid != _playerUid}) then {
                    systemChat format ["Mission Planner: only %1 can delete that mission save.", _ownerName];
                    _nextEntries pushBack _entry;
                } else {
                    _deleted = true;
                };
            } else {
                _nextEntries pushBack _entry;
            };
        };
    };
} forEach _entries;

if (!_deleted) exitWith {
    diag_log format ["[MP deleteConfig] EXIT: name not found in %1 entries", count _entries];
    false
};

_namespace setVariable [_key, _nextEntries];
if (!_isMissionScope) then {
    saveProfileNamespace;
};

diag_log format ["[MP deleteConfig] OK: deleted '%1' from scope=%2, %3 entries remain", _trimmedName, _scope, count _nextEntries];
true;
