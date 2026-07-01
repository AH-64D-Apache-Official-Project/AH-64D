// fza_mg_fnc_minigameNetSend - generic relay of a gameplay payload to the other party in a net-aware minigame session. Params: _gameId, _payload.
params [["_gameId", ""], ["_payload", []]];
if (_gameId == "") exitWith {};

private _heli = vehicle player;
if (!(_heli isKindOf "fza_ah64base")) exitWith {};
if (driver _heli != player && {gunner _heli != player}) exitWith {};

private _seat = [_heli] call fza_fnc_getSeat;
["fza_mg_netRelay", [_heli, _gameId, _seat, _payload, clientOwner]] call CBA_fnc_serverEvent;
