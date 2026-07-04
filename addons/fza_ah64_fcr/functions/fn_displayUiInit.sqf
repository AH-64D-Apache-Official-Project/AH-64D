disableSerialization;
params ["_mode", "_params"];
switch _mode do {
    case "onLoad": {
        _params params ["_display", ["_uniqueId", ""]];
        private _m = uiNamespace getVariable ["fza_mpd_htmlDisplay", createHashMap];
        uiNamespace setVariable ["fza_mpd_htmlDisplay", _m];
        _m set [_uniqueId, _display];
        _display setVariable ["fza_mpd_htmlUniqueId", _uniqueId];
        diag_log format ["[FCR displayUiInit] registered display uniqueId=%1 displayNull=%2", _uniqueId, isNull _display];

        // Register into fza_mpd_display so drawIcons targets the visible HTML display
        private _side = ["left", "right"] select ((_uniqueId find "right") == 0);
        private _n = uiNamespace getVariable ["fza_mpd_display", createHashMap];
        uiNamespace setVariable ["fza_mpd_display", _n];
        _n set [_side, _display];
        if !(_display getVariable ["fza_points_init", false]) then {
            _display setVariable ["fza_points",      createHashMap];
            _display setVariable ["fza_points_init", true];
        };

        private _p = [{displayUpdate (_this # 0);}, 0, _display] call CBA_fnc_addPerFrameHandler;
        _display setVariable ["fza_mpd_displayUpdatePfh", _p];
        _display displayAddEventHandler ["Unload", {
            params ["_d"];
            [_d getVariable "fza_mpd_displayUpdatePfh"] call CBA_fnc_removePerFrameHandler;
            private _uid = _d getVariable ["fza_mpd_htmlUniqueId", ""];
            if (_uid != "") then {
                private _m = uiNamespace getVariable ["fza_mpd_htmlDisplay", createHashMap];
                if ((_m getOrDefault [_uid, displayNull]) isEqualTo _d) then {
                    _m deleteAt _uid;
                };
            };
            // Restore native MPD pointer so subsequent non-HTML pages can use drawIcons
            private _side2 = ["left", "right"] select ((_uid find "right") == 0);
            private _nmpd  = uiNamespace getVariable ["fza_mpd_display", createHashMap];
            if ((_nmpd getOrDefault [_side2, displayNull]) isEqualTo _d) then {
                private _nativeDisp = uiNamespace getVariable ["RscFzaAH64MPD_" + _side2, displayNull];
                if (!isNull _nativeDisp) then { _nmpd set [_side2, _nativeDisp]; };
            };
            diag_log format ["[FCR displayUiInit] unregistered display uniqueId=%1", _uid];
        }];
    };
};
