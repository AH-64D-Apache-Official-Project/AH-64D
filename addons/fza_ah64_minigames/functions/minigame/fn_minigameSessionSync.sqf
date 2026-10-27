// fza_mg_fnc_minigameSessionSync - server: sends each member of a 2-player minigame session its view of it,
// ["session", role, peer ("none", "here" or "away"), myName, peerName, epoch], addressed to the member's page
// instance. Session layout is described in XEH_preInit.sqf. Params: _heli, _gameId.
params ["_heli", "_gameId"];
(_heli getVariable [format ["fza_mg_%1Session", _gameId], [[], 0]]) params ["_members", "_epoch"];
private _units = _members apply { [_x # 0] call fza_mg_fnc_minigameOwnerToUnit };
{
    private _unit = _units # _forEachIndex;
    if (!isNull _unit) then {
        private _peer = _members param [1 - _forEachIndex, []];
        private _peerUnit = _units param [1 - _forEachIndex, objNull];
        private _peerState = "none";
        if (_peer isNotEqualTo []) then { _peerState = ["away", "here"] select ((_peer # 2) < 0); };
        private _peerName = if (isNull _peerUnit) then {""} else {name _peerUnit};
        private _role = ["guest", "host"] select (_forEachIndex == 0);
        ["fza_mg_netRecv", [_x # 1, ["session", _role, _peerState, name _unit, _peerName, _epoch]], _unit] call CBA_fnc_targetEvent;
    };
} forEach _members;
