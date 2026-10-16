// fza_mg_fnc_minigameNetLeave - leaves a game's 2-player session from every display of that game. Params: _gameId.
params [["_gameId", "", [""]]];
if (_gameId == "") exitWith {};
{
    if ((_x getVariable ["fza_mg_gameId", ""]) == _gameId && {_x getVariable ["fza_mg_net", false]}) then {
        [_x, "leave"] call fza_mg_fnc_minigameNetPresence;
    };
} forEach values (uiNamespace getVariable ["fza_mpd_htmlDisplay", createHashMap]);
