// Called from CBA_common_PostInit, which fires as soon as CBA/networking is ready - well before "player" is
// guaranteed to have resolved to a real unit yet. getPlayerUID/profileName both need a real unit to query, so
// without waiting here the report can go out tagged with a blank/wrong UID and silently fail to attribute to
// the right player. (The existing JIP scoreboard request right next to this call gets away without waiting,
// since it keys off clientOwner - a connection-level id, not unit-dependent - which is why this needed its own.)
[] spawn {
    waitUntil {!isNull player};
    {
        private _gameId = _x;
        private _topKey = format ["fza_minigame_topscores_%1", _gameId];
        private _myTop = profileNamespace getVariable [_topKey, []];
        if (count _myTop > 0) then {
            ["fza_minigame_scoreReported", [_gameId, getPlayerUID player, profileName, _myTop]] call CBA_fnc_serverEvent;
        };
    } forEach ["asteroids", "spaceinvaders", "breakout", "lunarlander"];
};
