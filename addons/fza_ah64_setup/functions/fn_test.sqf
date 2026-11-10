/* ----------------------------------------------------------------------------
Function: fza_setup_fnc_test

Description:
    The controls test: a title layer showing the flight control inputs live,
    the game keeping its input, until Esc. The setup reopens after it.

Parameters:
    _mode - "start", "update" (each frame) or "stop" <STRING>

Returns:
    Nothing

Author:
    Snow(Dryden)
---------------------------------------------------------------------------- */
params ["_mode"];

#define TEST_TIMEOUT 600
#define CLAMP(v) (((v) max -1) min 1)
#define ON_COLOR "#d8ffd8"
#define OFF_COLOR "#4f6f4f"

switch (_mode) do {
    case "start": {
        if (!isNil "fza_setup_testFrame") exitWith {};
        private _main = findDisplay 46;
        if (isNull _main) exitWith {};
        ("fza_setup_test" call BIS_fnc_rscLayer) cutRsc ["RscFzaSetupTest", "PLAIN", 0, false];
        fza_setup_testStart = diag_tickTime;
        fza_setup_testCollAxis = ((actionKeys "bmkhs_collectiveUp") + (actionKeys "bmkhs_collectiveDn")) isNotEqualTo [];
        fza_setup_testFrame = addMissionEventHandler ["EachFrame", {["update"] call fza_setup_fnc_test}];
        // Esc ends the test rather than opening the pause menu
        fza_setup_testKey = _main displayAddEventHandler ["KeyDown", {
            params ["", "_key"];
            if (_key != 1) exitWith {false};
            [{["stop"] call fza_setup_fnc_test}] call CBA_fnc_execNextFrame;
            true
        }];
    };

    case "stop": {
        if (isNil "fza_setup_testFrame") exitWith {};
        removeMissionEventHandler ["EachFrame", fza_setup_testFrame];
        private _main = findDisplay 46;
        if (!isNull _main) then {_main displayRemoveEventHandler ["KeyDown", fza_setup_testKey]};
        fza_setup_testFrame = nil;
        fza_setup_testKey = nil;
        ("fza_setup_test" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
        [{[true] call fza_setup_fnc_open}] call CBA_fnc_execNextFrame;
    };

    case "update": {
        if (diag_tickTime - fza_setup_testStart > TEST_TIMEOUT || {!alive player}) exitWith {["stop"] call fza_setup_fnc_test};
        private _d = uiNamespace getVariable ["fza_setup_testDisplay", displayNull];
        if (isNull _d) exitWith {};

        // Laid out once in pixels, so the cyclic box is square on any screen
        private _layout = _d getVariable ["fza_setup_layout", []];
        if (_layout isEqualTo []) then {
            private _s  = (safeZoneH / pixelH) / 1000;
            private _ux = _s * pixelW;
            private _uy = _s * pixelH;
            private _x0 = safeZoneX + safeZoneW - 560 * _ux;
            private _y0 = safeZoneY + 140 * _uy;
            {
                _x params ["_idc", "_lx", "_ly", "_lw", "_lh"];
                private _c = _d displayCtrl _idc;
                _c ctrlSetPosition [_x0 + _lx * _ux, _y0 + _ly * _uy, _lw * _ux, _lh * _uy];
                if (ctrlType _c == 0) then {_c ctrlSetFontHeight (24 * _uy)};
                _c ctrlCommit 0;
            } forEach [
                [200, 0, 0, 540, 520], [201, 16, 8, 508, 36], [210, 16, 56, 240, 240], [211, 16, 175, 240, 2],
                [212, 135, 56, 2, 240], [214, 16, 298, 120, 30], [215, 110, 298, 150, 30], [220, 276, 56, 44, 240],
                [222, 262, 298, 90, 30], [230, 16, 340, 304, 30], [231, 167, 340, 2, 30], [233, 16, 372, 120, 30],
                [240, 340, 56, 184, 320], [202, 16, 410, 508, 104]
            ];
            (_d displayCtrl 201) ctrlSetFontHeight (30 * _uy);
            (_d displayCtrl 201) ctrlSetText "CONTROLS TEST - PRESS ESC TO GO BACK";
            (_d displayCtrl 202) ctrlSetStructuredText parseText format [
                "<t size='%1'>Push each control to its stops. Forward moves the dot up, the collective fills from the bottom. A dot that moves the wrong way is a binding the wrong way round. With the engines running, these inputs fly the aircraft.</t>",
                (22 * _uy) / 0.04
            ];
            (_d displayCtrl 220) ctrlShow fza_setup_testCollAxis;
            (_d displayCtrl 221) ctrlShow fza_setup_testCollAxis;
            if (!fza_setup_testCollAxis) then {(_d displayCtrl 222) ctrlSetText "COLL: KEYS"};
            _layout = [
                [_x0 + 16 * _ux, _y0 + 56 * _uy, 240 * _ux, 240 * _uy],
                [12 * _ux, 12 * _uy],
                [_x0 + 276 * _ux, _y0 + 56 * _uy, 44 * _ux, 240 * _uy],
                [_x0 + 16 * _ux, _y0 + 340 * _uy, 304 * _ux, 30 * _uy],
                [8 * _ux],
                (22 * _uy) / 0.04
            ];
            _d setVariable ["fza_setup_layout", _layout];
        };
        _layout params ["_box", "_dot", "_coll", "_pedal", "_mark", "_textSize"];

        private _pitch = CLAMP((inputAction "bmkhs_cyclicForward") - (inputAction "bmkhs_cyclicBackward"));
        private _roll  = CLAMP((inputAction "bmkhs_cyclicRight") - (inputAction "bmkhs_cyclicLeft"));
        private _yaw   = CLAMP((inputAction "bmkhs_pedalRight") - (inputAction "bmkhs_pedalLeft"));

        _box params ["_bx", "_by", "_bw", "_bh"];
        _dot params ["_dw", "_dh"];
        private _c = _d displayCtrl 213;
        _c ctrlSetPosition [_bx + (_roll + 1) / 2 * _bw - _dw / 2, _by + (1 - _pitch) / 2 * _bh - _dh / 2, _dw, _dh];
        _c ctrlCommit 0;
        (_d displayCtrl 215) ctrlSetText format ["P %1  R %2", _pitch toFixed 2, _roll toFixed 2];

        if (fza_setup_testCollAxis) then {
            private _level = (CLAMP((inputAction "bmkhs_collectiveUp") - (inputAction "bmkhs_collectiveDn")) + 1) / 2;
            _coll params ["_cx", "_cy", "_cw", "_ch"];
            _c = _d displayCtrl 221;
            _c ctrlSetPosition [_cx, _cy + _ch * (1 - _level), _cw, _ch * _level];
            _c ctrlCommit 0;
        };

        _pedal params ["_px", "_py", "_pw", "_ph"];
        _c = _d displayCtrl 232;
        _c ctrlSetPosition [_px + (_yaw + 1) / 2 * _pw - (_mark # 0) / 2, _py, _mark # 0, _ph];
        _c ctrlCommit 0;

        private _buttons = [["Force Trim", "bmkhs_forceTrim"], ["Interact", "hct_interaction_use"], ["Mouse Cursor", "hct_interaction_cursor"]];
        if (!fza_setup_testCollAxis) then {
            _buttons = [["Collective Up", "bmkhs_kbCollectiveUp"], ["Collective Down", "bmkhs_kbCollectiveDn"]] + _buttons;
        };
        private _text = format ["<t size='%1'>", _textSize];
        {
            _x params ["_label", "_action"];
            _text = _text + format ["<t color='%1'>%2 %3</t><br/>", [OFF_COLOR, ON_COLOR] select (inputAction _action > 0.5), ["-", "#"] select (inputAction _action > 0.5), _label];
        } forEach _buttons;
        _text = _text + "</t>";
        if (_text != (_d getVariable ["fza_setup_buttons", ""])) then {
            _d setVariable ["fza_setup_buttons", _text];
            (_d displayCtrl 240) ctrlSetStructuredText parseText _text;
        };
    };
};
