{
    private _gameId = _x;
    private _topKey = format ["fza_minigame_topscores_%1", _gameId];
    private _myTop = profileNamespace getVariable [_topKey, []];
    if (count _myTop > 0) then {
        ["fza_minigame_scoreReported", [_gameId, getPlayerUID player, profileName, _myTop]] call CBA_fnc_serverEvent;
    };
} forEach ["asteroids", "spaceinvaders", "breakout", "lunarlander"];
