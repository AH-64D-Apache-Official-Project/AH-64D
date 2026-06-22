// fza_mg_fnc_minigameReady - called via JS bridge once a minigame's page has loaded; pushes mute state + scoreboard. Params: _gameId.
disableSerialization;
params [["_gameId", ""]];

private _pushAll = {
    params ["_gameId"];
    [_gameId] call fza_mg_fnc_minigamePushScores;

    private _muted = profileNamespace getVariable ["fza_minigame_muted", false];
    private _jsCode = format ["if (window.fza_minigame_setMuted) window.fza_minigame_setMuted(%1);", _muted];
    private _loadedMPDs = uiNamespace getVariable ["fza_mpd_minigameDisplay", createHashMap];
    {
        private _browserCtrl = _x displayCtrl 369;
        if (!isNull _browserCtrl) then {
            // String + call compile sidesteps HEMTT's parser not recognising ctrlWebBrowserAction directly.
            [_browserCtrl, _jsCode] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
        };
    } forEach (values _loadedMPDs);
};

// Pushed twice - CEF can be slow to accept ExecJS calls right as the page finishes loading, so the very first push can be silently dropped.
[_gameId] call _pushAll;
[_gameId, _pushAll] spawn {
    params ["_gameId", "_pushAll"];
    sleep 1;
    [_gameId] call _pushAll;
};
