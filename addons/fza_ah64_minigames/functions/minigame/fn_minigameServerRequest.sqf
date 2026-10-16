// fza_mg_fnc_minigameServerRequest - server entry point for client minigame requests (remoteExecCall to 2). The sender
// comes from remoteExecutedOwner and the score owner from the sender's unit, never from the message, so one client
// cannot act for another. Raises the matching local event (handlers in XEH_preInit.sqf). Params: _event, _args.
params [["_event", "", [""]], ["_args", [], [[]]]];
if (!isServer) exitWith {};
private _sender = remoteExecutedOwner;
if (_sender == 0) then { _sender = clientOwner; };

private _valid = false;
if (_event in ["fza_mg_netJoin", "fza_mg_netAway", "fza_mg_netLeave", "fza_mg_netRelay"]) then {
    // [heli, gameId, page instance id] or, for a relay, [heli, gameId, payload, page instance id] - the owner is appended here
    private _relay = _event == "fza_mg_netRelay";
    _args params [["_heli", objNull], ["_gameId", ""], ["_data", ""], ["_inst", ""]];
    if (!_relay) then { _inst = _data; };
    private _ok = _inst isEqualType "" && { !_relay || { _data isEqualType [] } };
    if (_ok && { _heli isEqualType objNull } && { _heli isKindOf "fza_ah64base" } && { _gameId isEqualType "" } && { _gameId != "" } && { count _gameId <= 32 }) then {
        _args = [[_heli, _gameId, _inst, _sender], [_heli, _gameId, _data, _inst, _sender]] select _relay;
        _valid = true;
    };
};
if (_event == "fza_minigame_requestScores") then {
    _args = [_sender];
    _valid = true;
};
if (_event == "fza_minigame_scoreReported") then {
    // Identity from the connection, not the unit: reports sent at mission start arrive before the server lists the unit
    private _identity = if (isMultiplayer) then {
        private _info = ((allUsers apply { getUserInfo _x }) select { (_x param [1, -1]) == _sender }) param [0, []];
        [_info param [2, ""], _info param [3, ""]]
    } else {
        [getPlayerUID player, profileName]
    };
    if ((_identity # 0) != "" && { count _args >= 4 }) then {
        _args resize 4;
        _args set [1, _identity # 0];
        _args set [2, _identity # 1];
        _valid = true;
    };
};
if (_valid) then { [_event, _args] call CBA_fnc_localEvent; };
