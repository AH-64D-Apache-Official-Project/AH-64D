// fza_mg_fnc_minigameReportResult - generic win/loss record tracking (local only, profileNamespace, no networking
// needed since it's a personal stat). Immediately pushes the updated record back to every open display actually
// showing this gameId. Params: _gameId, _won.
params [["_gameId", ""], ["_won", false]];
if (_gameId == "") exitWith {};

private _suffix = ["losses", "wins"] select _won;
private _key = format ["fza_minigame_%1_%2", _gameId, _suffix];
profileNamespace setVariable [_key, (profileNamespace getVariable [_key, 0]) + 1];
saveProfileNamespace;

private _wins = profileNamespace getVariable [format ["fza_minigame_%1_wins", _gameId], 0];
private _losses = profileNamespace getVariable [format ["fza_minigame_%1_losses", _gameId], 0];
private _jsCode = format ["if (window.fza_minigame_setRecord) window.fza_minigame_setRecord(%1, %2);", _wins, _losses];
[_gameId, _jsCode] call fza_mg_fnc_minigamePushJsToGame;
