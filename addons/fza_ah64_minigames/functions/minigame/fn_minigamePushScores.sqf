// fza_mg_fnc_minigamePushScores - pushes own high score + global top-10 (pooled from everyone's top-10 lists) into every open minigame browser. Params: _gameId.
disableSerialization;
params [["_gameId", ""]];
if (_gameId == "") exitWith {};

private _topKey = format ["fza_minigame_topscores_%1", _gameId];
private _myTop = profileNamespace getVariable [_topKey, []];
private _myHighScore = if (count _myTop > 0) then {_myTop#0} else {0};

// Own entries come from the local top-10 directly (always current, even before reported to the server this session) - server entries for our own UID are skipped to avoid double-counting.
private _myUid = getPlayerUID player;
private _allScores = missionNamespace getVariable ["fza_minigame_scores", createHashMap];
private _gameScores = _allScores getOrDefault [_gameId, createHashMap];
private _entries = [];
{
    if (_x != _myUid) then {
        (_gameScores get _x) params ["_name", "_scores"];
        {_entries pushBack [_name, _x]} forEach _scores;
    };
} forEach (keys _gameScores);
{_entries pushBack [profileName, _x]} forEach _myTop;
private _sorted = [_entries, [], {_x select 1}, "DESCEND"] call BIS_fnc_sortBy;
private _top = _sorted select [0, 10 min count _sorted];

// str on an array is already valid JS array literal syntax, so it can be inlined straight into the JS call.
private _jsCode = format ["if (window.fza_minigame_setScores) window.fza_minigame_setScores(%1, %2);", _myHighScore, str _top];
private _loadedMPDs = uiNamespace getVariable ["fza_mpd_minigameDisplay", createHashMap];
{
    private _browserCtrl = _x displayCtrl 369;
    if (!isNull _browserCtrl) then {
        [_browserCtrl, _jsCode] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
    };
} forEach (values _loadedMPDs);
