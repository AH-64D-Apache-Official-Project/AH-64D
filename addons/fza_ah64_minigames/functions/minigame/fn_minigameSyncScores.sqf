// Called once in the mission (XEH_preInit.sqf): reports this player's saved top-10s so others see them without playing first.
// The server takes the identity from the connection (fn_minigameServerRequest.sqf), not from these arguments.
[] spawn {
    waitUntil {!isNull player};
    {
        private _gameId = _x;
        private _topKey = format ["fza_minigame_topscores_%1", _gameId];
        private _myTop = profileNamespace getVariable [_topKey, []];
        if (count _myTop > 0) then {
            ["fza_minigame_scoreReported", [_gameId, "", "", _myTop]] remoteExecCall ["fza_mg_fnc_minigameServerRequest", 2];
        };
    } forEach ["asteroids", "spaceinvaders", "breakout", "lunarlander"];
};
