// fza_mg_fnc_minigamePageLeft - called by fza_mpd_fnc_setCurrentPage when an MPD leaves an HTML page. Stops that game's
// music, unless the same game is still open on the other MPD. A 2-player session is not left here: the page's
// per-frame handler marks the player away instead, so an auto-page does not end a match. Params: _heli, _side, _oldUrl.
params ["_heli", "_side", ["_oldUrl", "", [""]]];
private _gameId = [_oldUrl] call fza_mg_fnc_minigameGameIdOf;
if (_gameId == "") exitWith {};
private _otherUrl = ((_heli getVariable ["fza_mpd_mpdState", []]) param [1 - _side, []]) param [8, ""];
if (([_otherUrl] call fza_mg_fnc_minigameGameIdOf) == _gameId) exitWith {};
[_gameId] call fza_mg_fnc_minigameStopMusic;
