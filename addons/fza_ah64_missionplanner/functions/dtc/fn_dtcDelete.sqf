params [["_scope", "own", [""]], ["_name", "", [""]]];

private _mission = _scope == "mission";
private _key = ["fza_mplanner_dtc_own", "fza_mplanner_dtc_mission"] select _mission;
private _namespace = [profileNamespace, missionNamespace] select _mission;

// That name on this map; the same name on another map stays
private _saves = (_namespace getVariable [_key, []]) select {
    _x isEqualType [] && {_x isEqualTypeParams ["", ""]} && {(_x # 0) != _name || {(_x param [2, worldName]) != worldName}}
};
if (_mission) then {
    missionNamespace setVariable [_key, _saves, true];
} else {
    profileNamespace setVariable [_key, _saves];
    saveProfileNamespace;
};
["saves"] call fza_mplanner_fnc_dtcSeed;
