// fza_mg_fnc_minigameSetMuted - toggles the global mute preference, persists it, pushes to all open minigame browsers. Params: _gameId, _muted.
disableSerialization;
params [["_gameId", ""], ["_muted", true]];

profileNamespace setVariable ["fza_minigame_muted", _muted];
saveProfileNamespace;

private _jsCode = format ["if (window.fza_minigame_setMuted) window.fza_minigame_setMuted(%1);", _muted];
private _loadedMPDs = uiNamespace getVariable ["fza_mpd_minigameDisplay", createHashMap];

{
    private _browserCtrl = _x displayCtrl 369;
    if (!isNull _browserCtrl) then {
        // String + call compile sidesteps HEMTT's parser not recognising ctrlWebBrowserAction directly.
        [_browserCtrl, _jsCode] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
    };
} forEach (values _loadedMPDs);
