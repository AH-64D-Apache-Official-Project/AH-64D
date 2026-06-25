// Minigame scoreboard sync, keyed by gameId: missionNamespace#fza_minigame_scores = HashMap<gameId, HashMap<playerUID, [name, [top10 scores]]>>
if (isServer) then {
    ["fza_minigame_scoreReported", {
        params ["_gameId", "_uid", "_name", "_myTop"];
        private _allScores = missionNamespace getVariable ["fza_minigame_scores", createHashMap];
        private _gameScores = _allScores getOrDefault [_gameId, createHashMap];
        _gameScores set [_uid, [_name, _myTop]];
        _allScores set [_gameId, _gameScores];
        missionNamespace setVariable ["fza_minigame_scores", _allScores];
        ["fza_minigame_scoresUpdated", [_allScores]] call CBA_fnc_globalEvent;
    }] call CBA_fnc_addEventHandler;

    // CBA_fnc_targetEvent is [_eventName, _params, _targets] - _targets must be an object/group, not a raw owner id,
    // so the requesting client's owner id is converted back to a unit via fza_mg_fnc_minigameOwnerToUnit.
    ["fza_minigame_requestScores", {
        params ["_clientOwner"];
        private _allScores = missionNamespace getVariable ["fza_minigame_scores", createHashMap];
        private _targetUnit = [_clientOwner] call fza_mg_fnc_minigameOwnerToUnit;
        if (!isNull _targetUnit) then {
            ["fza_minigame_scoresUpdated", [_allScores], _targetUnit] call CBA_fnc_targetEvent;
        };
    }] call CBA_fnc_addEventHandler;

    // Generic 2-player session tracking for net-aware minigames (currently just Pong). Session lives directly on the
    // heli, keyed dynamically by gameId so any future 2-player game gets its own session for free:
    //   _heli getVariable "fza_mg_<gameId>Session" = [hostOwner, hostSeat, guestOwner, guestSeat] ; -1/"" when absent.
    // Every handler below is fully self-contained (no shared local helper closures) - CBA_fnc_addEventHandler
    // callbacks do not reliably retain access to private variables from the enclosing XEH_preInit.sqf scope
    // (confirmed via RPT: "Error Type Any, expected String" when a handler tried to call a captured closure).
    ["fza_mg_netJoin", {
        params ["_heli", "_gameId", "_seat", "_clientOwner"];
        private _sessionKey = format ["fza_mg_%1Session", _gameId];
        private _session = _heli getVariable [_sessionKey, [-1, "", -1, ""]];
        _session params ["_hostOwner", "_hostSeat", "_guestOwner", "_guestSeat"];

        if (_hostOwner == -1) then {
            // No host yet - this client becomes host.
            _heli setVariable [_sessionKey, [_clientOwner, _seat, _guestOwner, _guestSeat]];
            private _targetUnit = [_clientOwner] call fza_mg_fnc_minigameOwnerToUnit;
            if (!isNull _targetUnit) then {
                ["fza_mg_netRole", [_heli, _gameId, "host", -1, name _targetUnit, ""], _targetUnit] call CBA_fnc_targetEvent;
            };
        } else {
            if (_hostOwner == _clientOwner && _hostSeat == _seat) then {
                // Same host re-opening - resend their current role unchanged.
                private _targetUnit = [_clientOwner] call fza_mg_fnc_minigameOwnerToUnit;
                if (!isNull _targetUnit) then {
                    private _guestUnit = [_guestOwner] call fza_mg_fnc_minigameOwnerToUnit;
                    private _peerName = if (!isNull _guestUnit) then {name _guestUnit} else {""};
                    ["fza_mg_netRole", [_heli, _gameId, "host", _guestOwner, name _targetUnit, _peerName], _targetUnit] call CBA_fnc_targetEvent;
                };
            } else {
                if (_guestOwner == _clientOwner && _guestSeat == _seat) then {
                    // Same guest re-opening - resend their current role unchanged.
                    private _targetUnit = [_clientOwner] call fza_mg_fnc_minigameOwnerToUnit;
                    if (!isNull _targetUnit) then {
                        private _hostUnit = [_hostOwner] call fza_mg_fnc_minigameOwnerToUnit;
                        private _peerName = if (!isNull _hostUnit) then {name _hostUnit} else {""};
                        ["fza_mg_netRole", [_heli, _gameId, "guest", _hostOwner, name _targetUnit, _peerName], _targetUnit] call CBA_fnc_targetEvent;
                    };
                } else {
                    if (_hostSeat != _seat && _guestOwner == -1) then {
                        // Host exists, different seat, no guest yet - this client becomes guest.
                        _heli setVariable [_sessionKey, [_hostOwner, _hostSeat, _clientOwner, _seat]];
                        private _guestUnit = [_clientOwner] call fza_mg_fnc_minigameOwnerToUnit;
                        private _hostUnit = [_hostOwner] call fza_mg_fnc_minigameOwnerToUnit;
                        private _hostName = if (!isNull _hostUnit) then {name _hostUnit} else {""};
                        private _guestName = if (!isNull _guestUnit) then {name _guestUnit} else {""};
                        if (!isNull _guestUnit) then {
                            ["fza_mg_netRole", [_heli, _gameId, "guest", _hostOwner, _guestName, _hostName], _guestUnit] call CBA_fnc_targetEvent;
                        };
                        if (!isNull _hostUnit) then {
                            ["fza_mg_netPeer", [_heli, _gameId, true, false, _guestName], _hostUnit] call CBA_fnc_targetEvent;
                        };
                    };
                    // Otherwise: both roles already taken by someone else for this seat pairing - ignore.
                };
            };
        };
    }] call CBA_fnc_addEventHandler;

    ["fza_mg_netLeave", {
        params ["_heli", "_gameId", "_seat", "_clientOwner"];
        private _sessionKey = format ["fza_mg_%1Session", _gameId];
        private _session = _heli getVariable [_sessionKey, [-1, "", -1, ""]];
        _session params ["_hostOwner", "_hostSeat", "_guestOwner", "_guestSeat"];

        if (_hostOwner == _clientOwner && _hostSeat == _seat) then {
            // Host leaves - session ends entirely.
            if (_guestOwner != -1) then {
                private _guestUnit = [_guestOwner] call fza_mg_fnc_minigameOwnerToUnit;
                if (!isNull _guestUnit) then {
                    ["fza_mg_netPeer", [_heli, _gameId, false, true, ""], _guestUnit] call CBA_fnc_targetEvent;
                };
            };
            _heli setVariable [_sessionKey, [-1, "", -1, ""]];
        } else {
            if (_guestOwner == _clientOwner && _guestSeat == _seat) then {
                // Guest leaves - host's AI resumes, session keeps running.
                _heli setVariable [_sessionKey, [_hostOwner, _hostSeat, -1, ""]];
                if (_hostOwner != -1) then {
                    private _hostUnit = [_hostOwner] call fza_mg_fnc_minigameOwnerToUnit;
                    if (!isNull _hostUnit) then {
                        ["fza_mg_netPeer", [_heli, _gameId, false, false, ""], _hostUnit] call CBA_fnc_targetEvent;
                    };
                };
            };
        };
    }] call CBA_fnc_addEventHandler;

    ["fza_mg_netRelay", {
        params ["_heli", "_gameId", "_seat", "_payload", "_clientOwner"];
        private _sessionKey = format ["fza_mg_%1Session", _gameId];
        private _session = _heli getVariable [_sessionKey, [-1, "", -1, ""]];
        _session params ["_hostOwner", "_hostSeat", "_guestOwner", "_guestSeat"];

        private _peerOwner = -1;
        if (_clientOwner == _hostOwner) then { _peerOwner = _guestOwner; };
        if (_clientOwner == _guestOwner) then { _peerOwner = _hostOwner; };

        if (_peerOwner != -1) then {
            private _targetUnit = [_peerOwner] call fza_mg_fnc_minigameOwnerToUnit;
            if (!isNull _targetUnit) then {
                ["fza_mg_netRecv", [_heli, _gameId, _payload], _targetUnit] call CBA_fnc_targetEvent;
            };
        };
    }] call CBA_fnc_addEventHandler;

    // Disconnect safety net - a crash/alt-F4 never sends a clean "fza_mg_netLeave", so scan every Apache for a
    // session the disconnecting player was part of. "owner _unit" (not the "_id" param) matches clientOwner's
    // numbering scheme - the unit is still local to the disconnecting client at this point in the handler.
    addMissionEventHandler ["HandleDisconnect", {
        params ["_unit"];
        private _disconnectedOwner = owner _unit;
        {
            private _heli = _x;
            {
                private _gameId = _x;
                private _sessionKey = format ["fza_mg_%1Session", _gameId];
                private _session = _heli getVariable [_sessionKey, [-1, "", -1, ""]];
                _session params ["_hostOwner", "_hostSeat", "_guestOwner", "_guestSeat"];
                if (_hostOwner == _disconnectedOwner) then {
                    if (_guestOwner != -1) then {
                        private _guestUnit = [_guestOwner] call fza_mg_fnc_minigameOwnerToUnit;
                        if (!isNull _guestUnit) then {
                            ["fza_mg_netPeer", [_heli, _gameId, false, true, ""], _guestUnit] call CBA_fnc_targetEvent;
                        };
                    };
                    _heli setVariable [_sessionKey, [-1, "", -1, ""]];
                } else {
                    if (_guestOwner == _disconnectedOwner) then {
                        _heli setVariable [_sessionKey, [_hostOwner, _hostSeat, -1, ""]];
                        if (_hostOwner != -1) then {
                            private _hostUnit = [_hostOwner] call fza_mg_fnc_minigameOwnerToUnit;
                            if (!isNull _hostUnit) then {
                                ["fza_mg_netPeer", [_heli, _gameId, false, false, ""], _hostUnit] call CBA_fnc_targetEvent;
                            };
                        };
                    };
                };
            } forEach ["pong", "battleship"];
        } forEach (vehicles select {_x isKindOf "fza_ah64base"});
    }];

    // Per-frame handler to clean up any sessions where the host or guest is no longer valid (e.g. they left the heli).
    [{
        {
            private _heli = _x;
            {
                private _gameId = _x;
                private _sessionKey = format ["fza_mg_%1Session", _gameId];
                private _session = _heli getVariable [_sessionKey, [-1, "", -1, ""]];
                _session params ["_hostOwner", "_hostSeat", "_guestOwner", "_guestSeat"];
                if (_hostOwner != -1 || _guestOwner != -1) then {
                    private _hostUnit = [_hostOwner] call fza_mg_fnc_minigameOwnerToUnit;
                    private _hostValid = !isNull _hostUnit && {if (_hostSeat == "plt") then {driver _heli == _hostUnit} else {gunner _heli == _hostUnit}};
                    private _guestUnit = [_guestOwner] call fza_mg_fnc_minigameOwnerToUnit;
                    private _guestValid = !isNull _guestUnit && {if (_guestSeat == "plt") then {driver _heli == _guestUnit} else {gunner _heli == _guestUnit}};

                    if (_hostOwner != -1 && !_hostValid) then {
                        if (_guestValid) then {
                            ["fza_mg_netPeer", [_heli, _gameId, false, true, ""], _guestUnit] call CBA_fnc_targetEvent;
                        };
                        _heli setVariable [_sessionKey, [-1, "", -1, ""]];
                    } else {
                        if (_guestOwner != -1 && !_guestValid) then {
                            if (_hostValid) then {
                                ["fza_mg_netPeer", [_heli, _gameId, false, false, ""], _hostUnit] call CBA_fnc_targetEvent;
                            };
                            _heli setVariable [_sessionKey, [_hostOwner, _hostSeat, -1, ""]];
                        };
                    };
                };
            } forEach ["pong", "battleship"];
        } forEach (vehicles select {_x isKindOf "fza_ah64base"});
    }, 3] call CBA_fnc_addPerFrameHandler;
};

["fza_minigame_scoresUpdated", {
    params ["_allScores"];
    missionNamespace setVariable ["fza_minigame_scores", _allScores];
    {[_x] call fza_mg_fnc_minigamePushScores} forEach (keys _allScores);
}] call CBA_fnc_addEventHandler;

// JIP backfill - ask the server for the current scoreboard once CBA/network is ready.
["CBA_common_PostInit", {
    if (hasInterface) then {
        ["fza_minigame_requestScores", [clientOwner]] call CBA_fnc_serverEvent;
    };
}] call CBA_fnc_addEventHandler;

// Minigame input uses plain native CfgUserActions (see fza_ah64_controls) - nothing to register here.

// Client-side receivers for the generic 2-player net session (currently just Pong) - every client needs these,
// not just the server, since these deliver the server's targeted replies into the local browser via ExecJS.
// Each is fully self-contained (fza_mg_fnc_minigameFindDisplay is a real CfgFunctions function, not a local
// closure, so it's safe to call from any context - unlike the local-helper approach that broke above).
["fza_mg_netRole", {
    params ["_heli", "_gameId", "_role", "_peerOwner", "_myName", "_peerName"];
    private _display = [_heli, _gameId] call fza_mg_fnc_minigameFindDisplay;
    if (isNull _display) exitWith {};
    private _browserCtrl = _display displayCtrl 369;
    if (isNull _browserCtrl) exitWith {};
    private _safeMyName = [_myName] call fza_mg_fnc_minigameEscapeJsString;
    private _safePeerName = [_peerName] call fza_mg_fnc_minigameEscapeJsString;
    private _jsCode = format ["if (window.fza_minigame_netRecv) window.fza_minigame_netRecv([""role"", ""%1"", %2, ""%3"", ""%4""]);", _role, _peerOwner, _safeMyName, _safePeerName];
    [_browserCtrl, _jsCode] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
}] call CBA_fnc_addEventHandler;

["fza_mg_netPeer", {
    params ["_heli", "_gameId", "_connected", "_hostLeft", "_peerName"];
    private _display = [_heli, _gameId] call fza_mg_fnc_minigameFindDisplay;
    if (isNull _display) exitWith {};
    private _browserCtrl = _display displayCtrl 369;
    if (isNull _browserCtrl) exitWith {};
    private _safePeerName = [_peerName] call fza_mg_fnc_minigameEscapeJsString;
    private _jsCode = format ["if (window.fza_minigame_netRecv) window.fza_minigame_netRecv([""peer"", %1, %2, ""%3""]);", _connected, _hostLeft, _safePeerName];
    [_browserCtrl, _jsCode] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
}] call CBA_fnc_addEventHandler;

["fza_mg_netRecv", {
    params ["_heli", "_gameId", "_payload"];
    private _display = [_heli, _gameId] call fza_mg_fnc_minigameFindDisplay;
    if (isNull _display) exitWith {};
    private _browserCtrl = _display displayCtrl 369;
    if (isNull _browserCtrl) exitWith {};
    private _jsCode = format ["if (window.fza_minigame_netRecv) window.fza_minigame_netRecv(%1);", str _payload];
    [_browserCtrl, _jsCode] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
}] call CBA_fnc_addEventHandler;
