// fza_mg_fnc_minigameReportScore - called via JS bridge on game-over; updates local top-10, reports the whole list to the server. Params: _gameId, _score.
params [["_gameId", "", [""]], ["_score", 0, [0]]];
if (_gameId == "" || { !finite _score }) exitWith {};
_score = round _score;

private _topKey = format ["fza_minigame_topscores_%1", _gameId];
private _myTop = profileNamespace getVariable [_topKey, []];
_myTop pushBack _score;
_myTop sort false; // descending
_myTop = _myTop select [0, 10 min count _myTop];
profileNamespace setVariable [_topKey, _myTop];
saveProfileNamespace;

["fza_minigame_scoreReported", [_gameId, "", "", _myTop]] remoteExecCall ["fza_mg_fnc_minigameServerRequest", 2];
