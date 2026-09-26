// fza_mg_fnc_minigamePushJsToGame - runs the given JS code in every LOCAL display currently showing the given
// gameId, and only those - never in a different game sharing the same uiNamespace hashmap. Without this, pushing
// e.g. Asteroids' scoreboard would also overwrite a different game's display if the local player has more than one
// minigame open at once (left + right MPD). Params: _gameId, _jsCode.
params [["_gameId", ""], ["_jsCode", ""]];
if (_gameId == "" || _jsCode == "") exitWith {};

private _heli = vehicle player;
if (!(_heli isKindOf "fza_ah64base")) exitWith {};

private _mpdState = _heli getVariable ["fza_mpd_mpdState", []];
private _loadedMPDs = uiNamespace getVariable ["fza_mpd_minigameDisplay", createHashMap];
{
    private _minigameUrl = _x select 8;
    if (_minigameUrl != "" && {(_minigameUrl find ("\" + _gameId + "\")) != -1}) then {
        private _uniqueId = _x select 9;
        private _display = _loadedMPDs getOrDefault [_uniqueId, displayNull];
        if (!isNull _display) then {
            private _browserCtrl = _display displayCtrl 369;
            if (!isNull _browserCtrl) then {
                [_browserCtrl, _jsCode] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
            };
        };
    };
} forEach _mpdState;
