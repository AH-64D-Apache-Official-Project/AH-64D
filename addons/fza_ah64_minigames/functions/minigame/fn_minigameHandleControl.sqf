// fza_mg_fnc_minigameHandleControl - generic bezel-button handler for minigame pages: b4 restarts, b5 toggles pause, b6 toggles mute, b1 exits to the minigame menu. Params: _heli, _mpdIndex, _control.
params ["_heli", "_mpdIndex", "_control"];

switch (_control) do {
    case "b1": {
        [_heli, _mpdIndex, "minigames"] call fza_mpd_fnc_setCurrentPage;
    };
    case "b4": {
        [_heli, _mpdIndex] call fza_mg_fnc_minigameRestart;
    };
    case "b5": {
        private _uniqueId = ((_heli getVariable ["fza_mpd_mpdState", []]) # _mpdIndex) select 9;
        private _display = (uiNamespace getVariable ["fza_mpd_minigameDisplay", createHashMap]) getOrDefault [_uniqueId, displayNull];
        if (!isNull _display) then {
            [_display, !(_display getVariable ["fza_mpd_minigameManualPaused", false])] call fza_mg_fnc_minigameSetPaused;
        };
    };
    case "b6": {
        ["", !(profileNamespace getVariable ["fza_minigame_muted", false])] call fza_mg_fnc_minigameSetMuted;
    };
};
