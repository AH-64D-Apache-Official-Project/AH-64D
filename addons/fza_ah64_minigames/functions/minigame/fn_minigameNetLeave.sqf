// fza_mg_fnc_minigameNetLeave - generic 2-player session leave/cleanup for net-aware minigames. Params: _gameId.
params [["_gameId", ""]];
if (_gameId == "") exitWith {};

private _heli = vehicle player;
if (!(_heli isKindOf "fza_ah64base")) exitWith {};
if (driver _heli != player && {gunner _heli != player}) exitWith {};

private _seat = [_heli] call fza_fnc_getSeat;
["fza_mg_netLeave", [_heli, _gameId, _seat, clientOwner]] call CBA_fnc_serverEvent;
