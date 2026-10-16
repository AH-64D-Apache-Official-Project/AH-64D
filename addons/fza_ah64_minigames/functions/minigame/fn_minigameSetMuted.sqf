// fza_mg_fnc_minigameSetMuted - toggles the global mute preference, persists it, pushes to all open minigame browsers. Params: _gameId, _muted.
disableSerialization;
params [["_gameId", "", [""]], ["_muted", false, [false]]];

profileNamespace setVariable ["fza_minigame_muted", _muted];
saveProfileNamespace;

// Stopped here directly, so muting does not depend on the push below reaching the page
if (_muted) then {
    { [_x] call fza_mg_fnc_minigameStopMusic; } forEach (missionNamespace getVariable ["fza_minigame_musicGames", []]);
};

private _jsCode = format ["if (window.fza_minigame_setMuted) window.fza_minigame_setMuted(%1);", _muted];
private _loadedMPDs = uiNamespace getVariable ["fza_mpd_htmlDisplay", createHashMap];

{
    // The map also holds non-minigame HTML pages (FCR)
    if (_x getVariable ["fza_mpd_isMinigame", false]) then {
        [_x displayCtrl 369, _jsCode] call fza_mpd_fnc_execJs;
    };
} forEach (values _loadedMPDs);
