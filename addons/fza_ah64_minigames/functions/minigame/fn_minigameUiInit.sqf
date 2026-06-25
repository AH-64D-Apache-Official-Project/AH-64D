disableSerialization;
params ["_mode", "_params", "_class"];
switch _mode do {
    case "onLoad": {
        _params params ["_display", ["_uniqueId",""]];
        private _loadedMPDs = uiNamespace getVariable ["fza_mpd_minigameDisplay", createHashMap];
        uiNamespace setVariable ["fza_mpd_minigameDisplay", _loadedMPDs];
        _loadedMPDs set [_uniqueId, _display];
        _display setVariable ["fza_mpd_minigameUniqueId", _uniqueId];

        // JS->SQF bridge via A3API.SendAlert (see bridge.js) - window.confirm() gets rejected by the _isConfirmDialog guard below.
        private _eventName = ["JS", "Dialog"] joinString "";
        private _browserCtrl = _display displayCtrl 369;
        if (!isNull _browserCtrl) then {
            _browserCtrl ctrlAddEventHandler [_eventName, {
                params ["_control", "_isConfirmDialog", "_message"];
                if (_isConfirmDialog) exitWith {false};
                if !(_message isEqualType "") exitWith {false};
                if ((_message find "sqf:") != 0) exitWith {false};
                private _code = _message select [4];
                if (_code isEqualTo "") exitWith {false};
                call compile _code;
                true
            }];
        };
        // Per-frame handler to update the display and pause state.
        private _p = [{
            private _display = _this#0;
            displayUpdate _display;
            private _heli = vehicle player;
            private _inSeat = (_heli isKindOf "fza_ah64base") && {driver _heli == player || gunner _heli == player};
            private _isPaused = !_inSeat || {!isNull (findDisplay 49)};
            if (_isPaused != (_display getVariable ["fza_mpd_minigamePaused", false])) then {
                _display setVariable ["fza_mpd_minigamePaused", _isPaused];
                private _browserCtrl = _display displayCtrl 369;
                if (!isNull _browserCtrl) then {
                    [_browserCtrl, format ["window.fza_minigame_setPaused(%1);", _isPaused]] call compile "params ['_b','_c']; _b ctrlWebBrowserAction ['ExecJS', _c];";
                };
            };
        }, 0, _display] call CBA_fnc_addPerFrameHandler;
        _display setVariable ["fza_mpd_displayUpdatePfh", _p];
        _display displayAddEventHandler ["Unload", {
            params ["_display"];
            [_display getVariable "fza_mpd_displayUpdatePfh"] call CBA_fnc_removePerFrameHandler;
            // Net-aware games need their session cleaned up when navigated away from - harmless no-op if no session existed.
            {[_x] call fza_mg_fnc_minigameNetLeave;} forEach ["pong", "battleship", "tictactoe", "connectfour"];
            // Clean up the stale hashmap entry, unless something newer already replaced it.
            private _uniqueId = _display getVariable ["fza_mpd_minigameUniqueId", ""];
            if (_uniqueId != "") then {
                private _loadedMPDs = uiNamespace getVariable ["fza_mpd_minigameDisplay", createHashMap];
                if ((_loadedMPDs getOrDefault [_uniqueId, objNull]) isEqualTo _display) then {
                    _loadedMPDs deleteAt _uniqueId;
                };
            };
        }];
    };
};
