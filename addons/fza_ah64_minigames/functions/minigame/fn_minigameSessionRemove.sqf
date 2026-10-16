// fza_mg_fnc_minigameSessionRemove - server: takes a player out of a 2-player minigame session. Whoever remains becomes
// the host on their own (free to play the AI) and is told so. Params: _heli, _gameId, _owner, _inst ("" = any page instance).
params ["_heli", "_gameId", "_owner", ["_inst", ""]];
private _key = format ["fza_mg_%1Session", _gameId];
(_heli getVariable [_key, [[], 0]]) params ["_members", "_epoch"];
private _idx = _members findIf { (_x # 0) == _owner && {_inst == "" || {(_x # 1) == _inst}} };
if (_idx == -1) exitWith {};
_members deleteAt _idx;
_heli setVariable [_key, [_members, _epoch + 1]];
[_heli, _gameId] call fza_mg_fnc_minigameSessionSync;
