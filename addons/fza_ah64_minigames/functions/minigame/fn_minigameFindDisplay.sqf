// fza_mg_fnc_minigameFindDisplay - finds the loaded minigame display (if any) on this heli currently showing the given gameId. Params: _heli, _gameId. Returns: display or displayNull.
params ["_heli", ["_gameId", ""]];
private _mpdState = _heli getVariable ["fza_mpd_mpdState", []];
private _loadedMPDs = uiNamespace getVariable ["fza_mpd_minigameDisplay", createHashMap];
private _result = displayNull;

{
    private _minigameUrl = _x select 8;
    if (_minigameUrl != "" && {(_minigameUrl find ("\" + _gameId + "\")) != -1}) then {
        private _uniqueId = _x select 9;
        _result = _loadedMPDs getOrDefault [_uniqueId, displayNull];
    };
} forEach _mpdState;

_result
