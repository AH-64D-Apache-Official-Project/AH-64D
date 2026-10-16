/* ----------------------------------------------------------------------------
Function: fza_fcr_fnc_displayUiInit

Description:
    onLoad handler for the FCR browser displays (scope, RMAP, TPM). Registers
    the display in fza_mpd_htmlDisplay under its unique id and redraws it each
    frame while it is the page shown on its MPD.

Parameters:
    _mode   - "onLoad"
    _params - onLoad arguments: [_display, _uniqueId]

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
disableSerialization;
params ["_mode", "_params"];
switch _mode do {
    case "onLoad": {
        _params params ["_display", ["_uniqueId", ""]];
        private _m = uiNamespace getVariable ["fza_mpd_htmlDisplay", createHashMap];
        uiNamespace setVariable ["fza_mpd_htmlDisplay", _m];
        _m set [_uniqueId, _display];
        _display setVariable ["fza_mpd_htmlUniqueId", _uniqueId];

        // The engine keeps the display alive after its page is left, so only redraw it while it is on screen
        private _sideIdx = parseNumber ((_uniqueId find "right") == 0);
        private _p = [{
            (_this # 0) params ["_display", "_uniqueId", "_sideIdx"];
            private _state = (vehicle player) getVariable ["fza_mpd_mpdState", []];
            if (_uniqueId == "" || { ((_state param [_sideIdx, []]) param [9, ""]) == _uniqueId }) then {
                displayUpdate _display;
            };
        }, 0, [_display, _uniqueId, _sideIdx]] call CBA_fnc_addPerFrameHandler;
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
        }];
    };
};
