// fza_mg_fnc_minigameNetPresence - tells the server this minigame display has joined, gone away from (hidden, ESC or out
// of the seat) or left its game's 2-player session. Params: _display, _state ("join", "away" or "leave").
params ["_display", ["_state", "join", [""]]];
if (isNull _display || {!(_state in ["join", "away", "leave"])}) exitWith {};
private _gameId = _display getVariable ["fza_mg_gameId", ""];
if (_gameId == "") exitWith {};

// Away and leave go to the heli the session was joined on, which the player may have got out of by now
private _heli = if (_state == "join") then {vehicle player} else {_display getVariable ["fza_mg_heli", objNull]};
if (_state == "join" && {!(_heli isKindOf "fza_ah64base")}) exitWith {};
_display setVariable ["fza_mg_netState", _state];
if (isNull _heli) exitWith {};
_display setVariable ["fza_mg_heli", _heli];

private _event = "fza_mg_net" + toUpper (_state select [0, 1]) + (_state select [1]);
[_event, [_heli, _gameId, _display getVariable ["fza_mg_instanceId", ""]]] remoteExecCall ["fza_mg_fnc_minigameServerRequest", 2];
