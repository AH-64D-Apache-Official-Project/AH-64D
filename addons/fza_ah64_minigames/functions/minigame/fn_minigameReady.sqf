// fza_mg_fnc_minigameReady - called via JS bridge once a minigame's page has loaded; pushes mute state + scoreboard + win/loss record. Params: _gameId.
disableSerialization;
params [["_gameId", ""]];

private _pushAll = {
    params ["_gameId"];
    [_gameId] call fza_mg_fnc_minigamePushScores;

    private _muted = profileNamespace getVariable ["fza_minigame_muted", false];
    private _wins = profileNamespace getVariable [format ["fza_minigame_%1_wins", _gameId], 0];
    private _losses = profileNamespace getVariable [format ["fza_minigame_%1_losses", _gameId], 0];
    private _jsCode = format [
        "if (window.fza_minigame_setMuted) window.fza_minigame_setMuted(%1); if (window.fza_minigame_setRecord) window.fza_minigame_setRecord(%2, %3);",
        _muted, _wins, _losses
    ];
    [_gameId, _jsCode] call fza_mg_fnc_minigamePushJsToGame;
};

// Pushed twice - CEF can be slow to accept ExecJS calls right as the page finishes loading, so the very first push can be silently dropped.
[_gameId] call _pushAll;
[_gameId, _pushAll] spawn {
    params ["_gameId", "_pushAll"];
    sleep 1;
    [_gameId] call _pushAll;
};
