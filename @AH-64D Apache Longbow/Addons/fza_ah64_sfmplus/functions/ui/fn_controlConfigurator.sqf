#include "\fza_ah64_sfmplus\headers\idcMacros.hpp"
#include "\fza_ah64_sfmplus\headers\core.hpp"

params ["_mode", "_params"];

switch _mode do {
    case "onLoad": {
        _params params ["_disp"];

        private _controlTypeCombo = _disp displayCtrl IDC_RSCFZACONTROLCONFIGURATOR_CONTROL_TYPE_COMBO;
        ["onControlTypeSelChanged", [_controlTypeCombo, 0]] call fza_sfmplus_fnc_controlConfigurator;
    };
    case "onControlTypeSelChanged": {
        _params params ["_ctrl", "_sel"];

        private _isKbMouse = _sel == 0;
        private _disp = ctrlParent _ctrl;

        _disp displayCtrl IDC_RSCFZACONTROLCONFIGURATOR_KB_MOUSE_USED_COMBO ctrlShow _isKbMouse;
        _disp displayCtrl IDC_RSCFZACONTROLCONFIGURATOR_KB_MOUSE_USED_LABEL ctrlShow _isKbMouse;
        _disp displayCtrl IDC_RSCFZACONTROLCONFIGURATOR_JOY_REALISM_COMBO ctrlShow !_isKbMouse;
        _disp displayCtrl IDC_RSCFZACONTROLCONFIGURATOR_JOY_REALISM_LABEL ctrlShow !_isKbMouse;
        _disp displayCtrl IDC_RSCFZACONTROLCONFIGURATOR_JOY_RUDDER_COMBO ctrlShow !_isKbMouse;
        _disp displayCtrl IDC_RSCFZACONTROLCONFIGURATOR_JOY_RUDDER_LABEL ctrlShow !_isKbMouse;
    };
    case "onOkButtonClick": {
        _params params ["_ctrl"];

        private _disp = ctrlParent _ctrl;

        [_disp] spawn {
            params ["_disp"];

            private _ctrlControlType = _disp displayCtrl IDC_RSCFZACONTROLCONFIGURATOR_CONTROL_TYPE_COMBO;
            private _isKbMouse = lbCurSel _ctrlControlType == 0;

            private _settings = if _isKbMouse then {
                private _ctrlMouseUsed = _disp displayCtrl IDC_RSCFZACONTROLCONFIGURATOR_KB_MOUSE_USED_COMBO;
                private _mouseUsed = lbCurSel _ctrlMouseUsed == 1; 

                createHashMapFromArray
                    [ ["fza_ah64_sfmplusRealismSetting", CASUAL]
                    , ["fza_ah64_sfmPlusAutoPedal", true]
                    , ["fza_ah64_sfmPlusMouseAsJoystick", _mouseUsed]
                    ];
            } else {
                private _ctrlRealism = _disp displayCtrl IDC_RSCFZACONTROLCONFIGURATOR_JOY_REALISM_COMBO;
                private _realismMode = [CASUAL, REALISTIC] select lbCurSel _ctrlRealism;
                
                private _ctrlRudder = _disp displayCtrl IDC_RSCFZACONTROLCONFIGURATOR_JOY_RUDDER_COMBO;
                private _hasRudder = lbCurSel _ctrlRudder == 0;

                createHashMapFromArray
                    [ ["fza_ah64_sfmPlusRealismSetting", _realismMode]
                    , ["fza_ah64_sfmPlusAutoPedal", !_hasRudder]
                    , ["fza_ah64_sfmPlusMouseAsJoystick", false]
                    ];
            };

            private _displayFlag = createHashMapFromArray
                [ [true, "Enabled"]
                , [false, "Disabled"]
                ];

            private _displayRealism = createHashMapFromArray
                [ [CASUAL, "Casual"]
                , [REALISTIC, "Realistic"]
                ];

            private _render =
                [ ["fza_ah64_sfmPlusRealismSetting", "Realism", _displayRealism]
                , ["fza_ah64_sfmPlusAutoPedal", "AutoPedal", _displayFlag]
                , ["fza_ah64_sfmPlusMouseAsJoystick", "Mouse as Joystick", _displayFlag]
                ];

            private _textOutput = ["Given your choices, we recommend the following settings", lineBreak];

            {
                _x params ["_setting", "_name", "_renderer"];
                _textOutput pushBack formatText["%1: %2%3", _name, _renderer get (_settings get _setting), lineBreak];
            } forEach _render;

            private _apply = [composeText _textOutput, "Settings", "Apply", "Ignore", _disp] call BIS_fnc_guiMessage;

            if _apply then {
                [{{
                    [_x, _y, 0, "client", true] call CBA_settings_fnc_set;
                } forEach _this;}, _settings] call CBA_fnc_directCall;

                ["Settings Applied"] call BIS_fnc_guiMessage;
            };

            _disp closeDisplay 1;
        }
    }
};