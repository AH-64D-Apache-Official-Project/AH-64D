// fza_mg_fnc_minigameNetSend - generic relay of a gameplay payload to the other party in a net-aware minigame session.
// Params: _gameId, _payload, _inst (the sending page instance, added by fza_mg_fnc_minigameBridgeCall).
params [["_gameId", "", [""]], ["_payload", [], [[]]], ["_inst", "", [""]]];
if (_gameId == "") exitWith {};

private _heli = vehicle player;
if (!(_heli isKindOf "fza_ah64base")) exitWith {};

["fza_mg_netRelay", [_heli, _gameId, _payload, _inst]] remoteExecCall ["fza_mg_fnc_minigameServerRequest", 2];
