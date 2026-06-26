// fza_mg_fnc_minigameSetMuted - toggles the global mute preference, persists it, pushes to all open minigame browsers. Params: _gameId, _muted.
disableSerialization;
params [["_gameId", ""], ["_muted", false]];

profileNamespace setVariable ["fza_minigame_muted", _muted];
saveProfileNamespace;

// Direct SQF-side stop as well, not just the ExecJS push below - removes any dependency on that push actually reaching the browser for the stop to take effect. Doom is the only minigame using music so far; list more gameIds here if that changes.
if (_muted) then { ["doom"] call fza_mg_fnc_minigameStopMusic; };

private _jsCode = format ["if (window.fza_minigame_setMuted) window.fza_minigame_setMuted(%1);", _muted];
private _loadedMPDs = uiNamespace getVariable ["fza_mpd_minigameDisplay", createHashMap];

{
    private _browserCtrl = _x displayCtrl 369;
    if (!isNull _browserCtrl) then {
        // String + call compile sidesteps HEMTT's parser not recognising ctrlWebBrowserAction directly.
        [_browserCtrl, _jsCode] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
    };
} forEach (values _loadedMPDs);
