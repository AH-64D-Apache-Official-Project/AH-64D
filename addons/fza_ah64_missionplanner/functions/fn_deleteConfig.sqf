params [
    ["_scope", "own", [""]],
    ["_name", "", [""]]
];

private _trimmedName = trim _name;
if (_trimmedName isEqualTo "") exitWith {false};

private _isMissionScope = toLower _scope isEqualTo "mission";
private _key = ["fza_mplanner_saves_own", "fza_mplanner_saves_mission"] select _isMissionScope;
private _namespace = [profileNamespace, missionNamespace] select _isMissionScope;
private _playerUid = getPlayerUID player;

private _entries = +(_namespace getVariable [_key, []]);
if !(_entries isEqualType []) exitWith {false};

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
            private _entryName = str (_entry # 0);
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

if (!_deleted) exitWith {false};

_namespace setVariable [_key, _nextEntries];
if (!_isMissionScope) then {
    saveProfileNamespace;
};

true;
