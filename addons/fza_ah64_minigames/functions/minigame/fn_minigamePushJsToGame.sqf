// fza_mg_fnc_minigamePushJsToGame - runs the given JS code in every LOCAL display of the given gameId, and only those -
// never in a different game sharing the same uiNamespace hashmap. Includes pages kept alive off screen: re-showing a
// page does not reload it, so an update it missed (e.g. another player's score) would otherwise never reach it.
// Params: _gameId, _jsCode.
params [["_gameId", ""], ["_jsCode", ""]];
if (_gameId == "" || _jsCode == "") exitWith {};

private _displays = [];
// Pages on screen, whose gameId may not be stamped on the display yet on their first frame
private _mpdState = (vehicle player) getVariable ["fza_mpd_mpdState", []];
private _loadedMPDs = uiNamespace getVariable ["fza_mpd_htmlDisplay", createHashMap];
{
    if (([_x param [8, ""]] call fza_mg_fnc_minigameGameIdOf) == _gameId) then {
        _displays pushBackUnique (_loadedMPDs getOrDefault [_x param [9, ""], displayNull]);
    };
} forEach _mpdState;
{
    if ((_x getVariable ["fza_mg_gameId", ""]) == _gameId) then { _displays pushBackUnique _x; };
} forEach values _loadedMPDs;

{
    private _browserCtrl = _x displayCtrl 369;
    if (!isNull _browserCtrl) then {
        [_browserCtrl, _jsCode] call fza_mpd_fnc_execJs;
    };
} forEach (_displays select { !isNull _x });
