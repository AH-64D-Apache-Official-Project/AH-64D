// Minigame scoreboard sync, keyed by gameId: missionNamespace#fza_minigame_scores = HashMap<gameId, HashMap<playerUID, [name, [top10 scores]]>>
// Over the network the board travels as plain arrays, [[gameId, [[uid, name, [scores]], ...]], ...].
if (isServer) then {
    ["fza_minigame_scoreReported", {
        params [["_gameId", ""], ["_uid", ""], ["_name", ""], ["_myTop", []]];
        // Reported by clients: keep only well-formed entries, and cap what one report can add to the board
        if !(_gameId isEqualType "" && { _uid isEqualType "" } && { _name isEqualType "" } && { _myTop isEqualType [] }) exitWith {};
        if (_gameId == "" || _uid == "") exitWith {};
        _name  = _name select [0, 48];
        _myTop = (_myTop select { _x isEqualType 0 }) select [0, 10];
        private _allScores = missionNamespace getVariable ["fza_minigame_scores", createHashMap];
        if !(_gameId in _allScores || { count _allScores < 32 }) exitWith {};
        private _gameScores = _allScores getOrDefault [_gameId, createHashMap];
        _gameScores set [_uid, [_name, _myTop]];
        _allScores set [_gameId, _gameScores];
        missionNamespace setVariable ["fza_minigame_scores", _allScores];
        private _board = (keys _allScores) apply { private _game = _allScores get _x; [_x, (keys _game) apply { [_x] + (_game get _x) }] };
        ["fza_minigame_scoresUpdated", [_board]] call CBA_fnc_globalEvent;
    }] call CBA_fnc_addEventHandler;

    // Raised by fza_mg_fnc_minigameServerRequest with the sender's owner id. Replied to by owner, as a client asking
    // at mission start may not have a unit the server can address yet.
    ["fza_minigame_requestScores", {
        params ["_clientOwner"];
        private _allScores = missionNamespace getVariable ["fza_minigame_scores", createHashMap];
        private _board = (keys _allScores) apply { private _game = _allScores get _x; [_x, (keys _game) apply { [_x] + (_game get _x) }] };
        if (isMultiplayer) then {
            ["fza_minigame_scoresUpdated", [_board], _clientOwner] call CBA_fnc_ownerEvent;
        } else {
            ["fza_minigame_scoresUpdated", [_board]] call CBA_fnc_localEvent;
        };
    }] call CBA_fnc_addEventHandler;

    // 2-player sessions for net-aware minigames, one per heli and game, held on the server only:
    //   _heli getVariable "fza_mg_<gameId>Session" = [members, epoch]
    //   member = [owner, page instance id, awaySince (-1 while present), failed seat checks]; the first is the host.
    // Paging away, ESC or leaving the seat only marks a member away (fn_minigameUiInit.sqf), so a match survives an
    // auto-page; B1 back to the game list, a disconnect, leaving the heli or being away too long while the other
    // player waits removes them. The epoch goes up whenever the pairing changes or a member's page is replaced,
    // which tells both pages that any match in progress is void. Members are told via fza_mg_fnc_minigameSessionSync.
    // Shared logic lives in CfgFunctions functions: CBA event handlers here cannot call closures from this file.
    ["fza_mg_netJoin", {
        params ["_heli", "_gameId", "_inst", "_owner"];
        private _games = _heli getVariable ["fza_mg_sessionGames", []];
        if (!(_gameId in _games) && { count _games >= 16 }) exitWith {};
        private _key = format ["fza_mg_%1Session", _gameId];
        (_heli getVariable [_key, [[], 0]]) params ["_members", "_epoch"];

        // A member who is no longer aboard must not hold a place against someone who is
        private _count = count _members;
        _members = _members select {
            private _unit = [_x # 0] call fza_mg_fnc_minigameOwnerToUnit;
            (_x # 0) == _owner || { !isNull _unit && { objectParent _unit == _heli } }
        };
        if (count _members != _count) then { _epoch = _epoch + 1; };

        private _idx = _members findIf { (_x # 0) == _owner };
        if (_idx == -1) then {
            if (count _members < 2) then {
                _members pushBack [_owner, _inst, -1, 0];
                _epoch = _epoch + 1;
                _idx = count _members - 1;
            };
        } else {
            private _member = _members # _idx;
            if ((_member # 1) != _inst) then {
                _member set [1, _inst];
                _epoch = _epoch + 1;
            };
            _member set [2, -1];
        };
        if (_idx == -1) exitWith {
            // Both places taken by players still aboard - this page plays the AI on its own
            private _unit = [_owner] call fza_mg_fnc_minigameOwnerToUnit;
            if (!isNull _unit) then {
                ["fza_mg_netRecv", [_inst, ["session", "host", "none", name _unit, "", -1]], _unit] call CBA_fnc_targetEvent;
            };
        };
        // The away timeout only counts time someone was actually waiting, which starts now
        { if ((_x # 2) >= 0) then { _x set [2, diag_tickTime]; }; } forEach _members;
        _heli setVariable [_key, [_members, _epoch]];

        _games pushBackUnique _gameId;
        _heli setVariable ["fza_mg_sessionGames", _games];
        private _helis = missionNamespace getVariable ["fza_mg_sessionHelis", []];
        _helis pushBackUnique _heli;
        missionNamespace setVariable ["fza_mg_sessionHelis", _helis];
        [_heli, _gameId] call fza_mg_fnc_minigameSessionSync;
    }] call CBA_fnc_addEventHandler;

    ["fza_mg_netAway", {
        params ["_heli", "_gameId", "_inst", "_owner"];
        (_heli getVariable [format ["fza_mg_%1Session", _gameId], [[], 0]]) params ["_members"];
        private _idx = _members findIf { (_x # 0) == _owner && { (_x # 1) == _inst } };
        if (_idx == -1 || { ((_members # _idx) # 2) >= 0 }) exitWith {};
        (_members # _idx) set [2, diag_tickTime];
        [_heli, _gameId] call fza_mg_fnc_minigameSessionSync;
    }] call CBA_fnc_addEventHandler;

    ["fza_mg_netLeave", {
        params ["_heli", "_gameId", "_inst", "_owner"];
        [_heli, _gameId, _owner, _inst] call fza_mg_fnc_minigameSessionRemove;
    }] call CBA_fnc_addEventHandler;

    ["fza_mg_netRelay", {
        params ["_heli", "_gameId", "_payload", "_inst", "_owner"];
        // Session state only ever comes from the server
        if ((_payload param [0, ""]) isEqualTo "session") exitWith {};
        (_heli getVariable [format ["fza_mg_%1Session", _gameId], [[], 0]]) params ["_members"];
        // Only from the page holding the place, not a stale copy (e.g. the same game left open on the other MPD)
        private _idx = _members findIf { (_x # 0) == _owner && { (_x # 1) == _inst } };
        if (_idx == -1) exitWith {};
        private _peer = _members param [1 - _idx, []];
        if (_peer isEqualTo []) exitWith {};
        private _unit = [_peer # 0] call fza_mg_fnc_minigameOwnerToUnit;
        if (!isNull _unit) then {
            ["fza_mg_netRecv", [_peer # 1, _payload], _unit] call CBA_fnc_targetEvent;
        };
    }] call CBA_fnc_addEventHandler;

    // A crash or alt-F4 never sends a leave. "owner _unit" (not the "_id" param) matches clientOwner's numbering -
    // the unit is still local to the disconnecting client at this point.
    addMissionEventHandler ["HandleDisconnect", {
        params ["_unit"];
        private _owner = owner _unit;
        {
            private _heli = _x;
            {
                [_heli, _x, _owner] call fza_mg_fnc_minigameSessionRemove;
            } forEach (_heli getVariable ["fza_mg_sessionGames", []]);
        } forEach ((missionNamespace getVariable ["fza_mg_sessionHelis", []]) select { !isNull _x });
        false
    }];

    // Removes members who left the heli (3 failed checks in a row, so a seat change is not mistaken for leaving),
    // and members away for over 90 s while the other player is present and waiting on them.
    [{
        private _helis = (missionNamespace getVariable ["fza_mg_sessionHelis", []]) select { !isNull _x };
        missionNamespace setVariable ["fza_mg_sessionHelis", _helis];
        {
            private _heli = _x;
            {
                private _gameId = _x;
                (_heli getVariable [format ["fza_mg_%1Session", _gameId], [[], 0]]) params ["_members"];
                private _drop = [];
                {
                    _x params ["_owner", "_inst", "_awaySince", "_badChecks"];
                    private _unit = [_owner] call fza_mg_fnc_minigameOwnerToUnit;
                    _badChecks = if (!isNull _unit && { objectParent _unit == _heli }) then { 0 } else { _badChecks + 1 };
                    _x set [3, _badChecks];
                    private _peer = _members param [1 - _forEachIndex, []];
                    private _timedOut = _awaySince >= 0 && { _peer isNotEqualTo [] } && { (_peer # 2) < 0 } && { diag_tickTime - _awaySince > 90 };
                    if (_badChecks >= 3 || _timedOut) then { _drop pushBack _owner; };
                } forEach _members;
                { [_heli, _gameId, _x] call fza_mg_fnc_minigameSessionRemove; } forEach _drop;
            } forEach (_heli getVariable ["fza_mg_sessionGames", []]);
        } forEach _helis;
    }, 3] call CBA_fnc_addPerFrameHandler;
};

["fza_minigame_scoresUpdated", {
    params [["_board", []]];
    if !(_board isEqualType []) exitWith {};
    // The board arrives over the network, so only well-formed entries are kept
    private _allScores = createHashMap;
    {
        if (_x isEqualType [] && { (_x param [0, ""]) isEqualType "" } && { (_x param [1, 0]) isEqualType [] }) then {
            private _gameScores = createHashMap;
            {
                if (_x isEqualType [] && { (_x param [0, 0]) isEqualType "" } && { (_x param [1, 0]) isEqualType "" } && { (_x param [2, 0]) isEqualType [] }) then {
                    _gameScores set [_x # 0, [_x # 1, _x # 2]];
                };
            } forEach (_x # 1);
            _allScores set [_x # 0, _gameScores];
        };
    } forEach _board;
    missionNamespace setVariable ["fza_minigame_scores", _allScores];
    {[_x] call fza_mg_fnc_minigamePushScores} forEach (keys _allScores);
}] call CBA_fnc_addEventHandler;

// Once in the mission (JIP too): fetch the current scoreboard and report our own saved scores, so everyone sees them
// without playing first
if (hasInterface) then {
    [{ !isNull player && { time > 1 } }, {
        ["fza_minigame_requestScores", []] remoteExecCall ["fza_mg_fnc_minigameServerRequest", 2];
        [] call fza_mg_fnc_minigameSyncScores;
    }] call CBA_fnc_waitUntilAndExecute;
};

// Minigame input uses plain native CfgUserActions (see fza_ah64_controls) - nothing to register here.

// Client side of the 2-player minigame sessions: session state and relayed moves from the server, addressed to one page
// instance. Delivered even while that page is hidden, so a turn-based match keeps up while its player is paged away.
["fza_mg_netRecv", {
    params [["_inst", ""], ["_payload", []]];
    if !(_inst isEqualType "" && { _inst != "" } && { _payload isEqualType [] }) exitWith {};
    private _display = displayNull;
    {
        if ((_x getVariable ["fza_mg_instanceId", ""]) == _inst) exitWith { _display = _x; };
    } forEach values (uiNamespace getVariable ["fza_mpd_htmlDisplay", createHashMap]);
    if (isNull _display) exitWith {};
    private _browserCtrl = _display displayCtrl 369;
    if (isNull _browserCtrl) exitWith {};
    // Every value goes through the JS encoder: the payload arrives over the network and must stay data in the page
    private _jsCode = format ["if (window.fza_minigame_netRecv) window.fza_minigame_netRecv(%1);", [_payload] call fza_mg_fnc_minigameToJs];
    [_browserCtrl, _jsCode] call fza_mpd_fnc_execJs;
}] call CBA_fnc_addEventHandler;
