// Minigame scoreboard sync, keyed by gameId: missionNamespace#fza_minigame_scores = HashMap<gameId, HashMap<playerUID, [name, [top10 scores]]>>
if (isServer) then {
    ["fza_minigame_scoreReported", {
        params ["_gameId", "_uid", "_name", "_myTop"];
        private _allScores = missionNamespace getVariable ["fza_minigame_scores", createHashMap];
        private _gameScores = _allScores getOrDefault [_gameId, createHashMap];
        _gameScores set [_uid, [_name, _myTop]];
        _allScores set [_gameId, _gameScores];
        missionNamespace setVariable ["fza_minigame_scores", _allScores];
        ["fza_minigame_scoresUpdated", [_allScores]] call CBA_fnc_globalEvent;
    }] call CBA_fnc_addEventHandler;

    ["fza_minigame_requestScores", {
        params ["_clientOwner"];
        private _allScores = missionNamespace getVariable ["fza_minigame_scores", createHashMap];
        [_clientOwner, "fza_minigame_scoresUpdated", [_allScores]] call CBA_fnc_targetEvent;
    }] call CBA_fnc_addEventHandler;
};

["fza_minigame_scoresUpdated", {
    params ["_allScores"];
    missionNamespace setVariable ["fza_minigame_scores", _allScores];
    {[_x] call fza_mg_fnc_minigamePushScores} forEach (keys _allScores);
}] call CBA_fnc_addEventHandler;

// JIP backfill - ask the server for the current scoreboard once CBA/network is ready.
["CBA_common_PostInit", {
    if (hasInterface) then {
        ["fza_minigame_requestScores", [clientOwner]] call CBA_fnc_serverEvent;
    };
}] call CBA_fnc_addEventHandler;

// Minigame input uses plain native CfgUserActions (see fza_ah64_controls) - nothing to register here.
