// fza_mg_fnc_minigameHandleControl - generic bezel-button handler for minigame pages: b5 toggles pause, b6 toggles mute, b1 exits to the minigame menu. Params: _heli, _mpdIndex, _control.
params ["_heli", "_mpdIndex", "_control"];

switch (_control) do {
    case "b1": {
        [_heli, _mpdIndex, "minigames"] call fza_mpd_fnc_setCurrentPage;
    };
    case "b5": {
        private _sideName = (["left", "right"] select _mpdIndex) + "Game";
        private _display = (uiNamespace getVariable ["fza_mpd_minigameDisplay", createHashMap]) getOrDefault [_sideName, displayNull];
        if (!isNull _display) then {
            [_display, !(_display getVariable ["fza_mpd_minigameManualPaused", false])] call fza_mg_fnc_minigameSetPaused;
        };
    };
    case "b6": {
        ["", !(profileNamespace getVariable ["fza_minigame_muted", false])] call fza_mg_fnc_minigameSetMuted;
    };
};
