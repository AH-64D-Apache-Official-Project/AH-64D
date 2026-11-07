// A DTC saved by name: "own" in the player's profile, "mission" for everyone in the mission
params [["_scope", "own", [""]], ["_name", "", [""]], ["_json", "", [""]]];

_name = toUpper (_name select [0, 8]);
if (_name == "" || {_json == ""}) exitWith {};
private _mission = _scope == "mission";
private _key = ["fza_mplanner_dtc_own", "fza_mplanner_dtc_mission"] select _mission;
private _namespace = [profileNamespace, missionNamespace] select _mission;

private _saves = +(_namespace getVariable [_key, []]);
private _index = _saves findIf {(_x # 0) == _name};
private _entry = [_name, _json, worldName, profileName];
if (_index == -1) then {_saves pushBack _entry} else {_saves set [_index, _entry]};
if (_mission) then {
    missionNamespace setVariable [_key, _saves, true];
} else {
    profileNamespace setVariable [_key, _saves];
    saveProfileNamespace;
};
["saves"] call fza_mplanner_fnc_dtcSeed;
