// fza_mg_fnc_minigameNetJoin - generic 2-player session join handshake for net-aware minigames (currently just Pong). Params: _gameId.
params [["_gameId", ""]];
if (_gameId == "") exitWith {};

private _heli = vehicle player;
if (!(_heli isKindOf "fza_ah64base")) exitWith {};
if (driver _heli != player && {gunner _heli != player}) exitWith {};

private _seat = [_heli] call fza_fnc_getSeat;
diag_log format ["[fza_mg] netJoin: gameId=%1 seat=%2 heli=%3", _gameId, _seat, _heli];
// Direct, per-seat "is this seat's game genuinely open right now" flag - simpler and more robust than inferring
// it from host/guest pairing state, since it's set the moment this seat's own instance actually loads, regardless
// of whether pairing with a peer ever succeeds. Public so fn_coreGetWCAs.sqf can read it from any seat.
_heli setVariable [format ["fza_mg_%1Open_%2", _gameId, _seat], true, true];
["fza_mg_netJoin", [_heli, _gameId, _seat, clientOwner]] call CBA_fnc_serverEvent;
