disableSerialization;
params ["_mode", "_params", "_class"];
switch _mode do {
    case "onLoad": {
        _params params ["_display", ["_uniqueId",""]];
        private _loadedMPDs = uiNamespace getVariable ["fza_mpd_display", createHashMap];
        uiNamespace setVariable ["fza_mpd_display", _loadedMPDs];
        _loadedMPDs set [_uniqueId, _display];
        _display setVariable ["fza_points", createHashMap];
        // Cache native display reference so HTML pages can restore it on unload
        uiNamespace setVariable ["RscFzaAH64MPD_" + _uniqueId, _display];
    };
};
