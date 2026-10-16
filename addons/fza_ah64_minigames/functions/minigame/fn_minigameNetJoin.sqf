// fza_mg_fnc_minigameNetJoin - called by a net-aware minigame page once it has loaded. Marks the game's displays as
// 2-player, after which fn_minigameUiInit.sqf's per-frame handler joins the session whenever one is on screen and
// marks it away while it is not. Params: _gameId.
params [["_gameId", "", [""]]];
if (_gameId == "") exitWith {};

private _shown = [vehicle player, _gameId] call fza_mg_fnc_minigameFindDisplay;
if (!isNull _shown) then { _shown setVariable ["fza_mg_gameId", _gameId]; };
{
    if ((_x getVariable ["fza_mg_gameId", ""]) == _gameId) then {
        _x setVariable ["fza_mg_net", true];
        // Forces a fresh join/away on the next frame, as this may be a reloaded page
        _x setVariable ["fza_mg_netState", ""];
    };
} forEach values (uiNamespace getVariable ["fza_mpd_htmlDisplay", createHashMap]);
