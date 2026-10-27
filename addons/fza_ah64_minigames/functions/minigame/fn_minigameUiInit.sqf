disableSerialization;
params ["_mode", "_params", "_class"];
switch _mode do {
    case "onLoad": {
        _params params ["_display", ["_uniqueId",""]];
        private _loadedMPDs = uiNamespace getVariable ["fza_mpd_htmlDisplay", createHashMap];
        uiNamespace setVariable ["fza_mpd_htmlDisplay", _loadedMPDs];
        _loadedMPDs set [_uniqueId, _display];
        _display setVariable ["fza_mpd_htmlUniqueId", _uniqueId];
        // fza_mpd_htmlDisplay also holds non-minigame pages (FCR) - this marks the ones that speak the minigame bridge
        _display setVariable ["fza_mpd_isMinigame", true];
        private _pageUrl = (((vehicle player) getVariable ["fza_mpd_mpdState", []]) select { (_x param [9, ""]) isEqualTo _uniqueId }) param [0, []] param [8, ""];
        _display setVariable ["fza_mg_gameId", [_pageUrl] call fza_mg_fnc_minigameGameIdOf];
        // A 2-player session tracks this page load, not the player, so a reloaded page starts its match afresh
        private _loadCount = (uiNamespace getVariable ["fza_mg_pageLoads", 0]) + 1;
        uiNamespace setVariable ["fza_mg_pageLoads", _loadCount];
        _display setVariable ["fza_mg_instanceId", format ["%1:%2", _uniqueId, _loadCount]];

        // JS->SQF bridge via A3API.SendAlert (see bridge.js) - window.confirm() gets rejected by the _isConfirmDialog guard below.
        // The message is dispatched by fza_mg_fnc_minigameBridgeCall, never compiled.
        private _eventName = ["JS", "Dialog"] joinString "";
        private _browserCtrl = _display displayCtrl 369;
        if (!isNull _browserCtrl) then {
            _browserCtrl ctrlAddEventHandler [_eventName, {
                params ["_control", "_isConfirmDialog", "_message"];
                if (_isConfirmDialog) exitWith {false};
                if !(_message isEqualType "") exitWith {false};
                [_message, ctrlParent _control] call fza_mg_fnc_minigameBridgeCall
            }];
        };
        // Per-frame handler to update the display and pause state.
        private _sideIdx = parseNumber ((_uniqueId find "right") == 0);
        private _p = [{
            (_this # 0) params ["_display", "_uniqueId", "_sideIdx"];
            private _heli = vehicle player;
            private _inSeat = (_heli isKindOf "fza_ah64base") && {driver _heli == player || gunner _heli == player};
            // The engine keeps the display alive after its page is left - stop redrawing it and hold the game until it is shown again.
            private _onScreen = _uniqueId == "" || { (((_heli getVariable ["fza_mpd_mpdState", []]) param [_sideIdx, []]) param [9, ""]) isEqualTo _uniqueId };
            if (_onScreen) then {
                displayUpdate _display;
                if ((_display getVariable ["fza_mg_gameId", ""]) == "") then {
                    _display setVariable ["fza_mg_gameId", [((_heli getVariable ["fza_mpd_mpdState", []]) param [_sideIdx, []]) param [8, ""]] call fza_mg_fnc_minigameGameIdOf];
                };
            };
            private _isPaused = !_inSeat || !_onScreen || {!isNull (findDisplay 49)};
            if (_isPaused != (_display getVariable ["fza_mpd_minigamePaused", false])) then {
                _display setVariable ["fza_mpd_minigamePaused", _isPaused];
                private _browserCtrl = _display displayCtrl 369;
                if (!isNull _browserCtrl) then {
                    [_browserCtrl, format ["window.fza_minigame_setPaused(%1);", _isPaused]] call fza_mpd_fnc_execJs;
                };
            };
            // 2-player games: present while shown, away while paused. After B1 the page stays out until shown again.
            if (_display getVariable ["fza_mg_net", false]) then {
                private _want = ["join", "away"] select _isPaused;
                private _have = _display getVariable ["fza_mg_netState", ""];
                if (_want != _have && { _want == "join" || { _have != "leave" } }) then {
                    [_display, _want] call fza_mg_fnc_minigameNetPresence;
                };
            };
        }, 0, [_display, _uniqueId, _sideIdx]] call CBA_fnc_addPerFrameHandler;
        _display setVariable ["fza_mpd_displayUpdatePfh", _p];
        _display displayAddEventHandler ["Unload", {
            params ["_display"];
            [_display getVariable "fza_mpd_displayUpdatePfh"] call CBA_fnc_removePerFrameHandler;
            // This page instance is gone, so its session place goes too (the server ignores it if a newer page took over)
            if ((_display getVariable ["fza_mg_net", false]) && { (_display getVariable ["fza_mg_netState", ""]) != "leave" }) then {
                [_display, "leave"] call fza_mg_fnc_minigameNetPresence;
            };
            // Backstop for fza_mg_fnc_minigamePageLeft: this display's game only, and only if it is not open on an MPD now
            private _gameId = _display getVariable ["fza_mg_gameId", ""];
            private _shown = (((vehicle player) getVariable ["fza_mpd_mpdState", []]) findIf { ([_x param [8, ""]] call fza_mg_fnc_minigameGameIdOf) == _gameId }) != -1;
            if (_gameId != "" && !_shown) then {
                [_gameId] call fza_mg_fnc_minigameStopMusic;
            };
            // Clean up the stale hashmap entry, unless something newer already replaced it.
            private _uniqueId = _display getVariable ["fza_mpd_htmlUniqueId", ""];
            if (_uniqueId != "") then {
                private _loadedMPDs = uiNamespace getVariable ["fza_mpd_htmlDisplay", createHashMap];
                if ((_loadedMPDs getOrDefault [_uniqueId, objNull]) isEqualTo _display) then {
                    _loadedMPDs deleteAt _uniqueId;
                };
            };
        }];
    };
};
