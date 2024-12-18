params ["_mode", "_params", "_class"];
switch _mode do {
    case "onLoad": {
        _params params ["_display", ["_uniqueId",""]];
        uiNamespace setVariable ["fza_mpd_display", _display];
        _loadedMPDs set [_uniqueId, _display];
        _display setVariable ["fza_points_left", createHashMap];
        _display setVariable ["fza_points_right", createHashMap];
    };
};
