class RscFzaControlConfigurator
{
    idd = -1;

    onLoad = "[""onLoad"", _this] call fza_sfmplus_fnc_controlConfigurator";
    class ControlsBackground {
        class Background : RscText
        {
            idc = -1;
            x = GUI_GRID_CENTER_X + 9 * GUI_GRID_CENTER_W;
            y = GUI_GRID_CENTER_Y + 7 * GUI_GRID_CENTER_H;
            w = 22 * GUI_GRID_CENTER_W;
            h = 12 * GUI_GRID_CENTER_H;
            colorBackground[] = {0,0,0,0.8};
        };
    };
    class Controls {
        class ControlTypeLabel : RscText {
            idc = IDC_RSCFZACONTROLCONFIGURATOR_CONTROL_TYPE_LABEL;
            text = "What type of input device do you use?";

            x = GUI_GRID_CENTER_X + 10 * GUI_GRID_CENTER_W;
            y = GUI_GRID_CENTER_Y + 8 * GUI_GRID_CENTER_H;
            w = 20 * GUI_GRID_CENTER_W;
            h = GUI_GRID_CENTER_H;
        };

        class ControlTypeCombo : RscCombo {
            idc = IDC_RSCFZACONTROLCONFIGURATOR_CONTROL_TYPE_COMBO;
            class Items {
                class MouseKb {
                    text = "Mouse & Keyboard";
                    default = 1;
                };
                class Joystick {
                    text = "Joystick";
                };
            };

            x = GUI_GRID_CENTER_X + 10 * GUI_GRID_CENTER_W;
            y = GUI_GRID_CENTER_Y + 9 * GUI_GRID_CENTER_H;
            w = 10 * GUI_GRID_CENTER_W;
            h = GUI_GRID_CENTER_H;

            onLbSelChanged = "[""onControlTypeSelChanged"", _this] call fza_sfmplus_fnc_controlConfigurator";
        };

        class KbMouseUsedLabel : RscText {
            idc = IDC_RSCFZACONTROLCONFIGURATOR_KB_MOUSE_USED_LABEL;
            text = "Is the mouse part of your helicopter input?";

            x = GUI_GRID_CENTER_X + 10 * GUI_GRID_CENTER_W;
            y = GUI_GRID_CENTER_Y + 11 * GUI_GRID_CENTER_H;
            w = 20 * GUI_GRID_CENTER_W;
            h = GUI_GRID_CENTER_H;
        };

        class KbMouseUsedCombo : RscCombo {
            idc = IDC_RSCFZACONTROLCONFIGURATOR_KB_MOUSE_USED_COMBO;
            class Items {
                class MouseNotUsed {
                    text = "Mouse not used";
                    default = 1;
                };
                class MouseUsed {
                    text = "Mouse used";
                };
            };
            tooltip = "This will disable the inputs to the cyclic when in freelook";

            x = GUI_GRID_CENTER_X + 10 * GUI_GRID_CENTER_W;
            y = GUI_GRID_CENTER_Y + 12 * GUI_GRID_CENTER_H;
            w = 10 * GUI_GRID_CENTER_W;
            h = GUI_GRID_CENTER_H;
        };

        class JoyRealismLabel : RscText {
            idc = IDC_RSCFZACONTROLCONFIGURATOR_JOY_REALISM_LABEL;
            text = "What is your referred realism mode?";

            x = GUI_GRID_CENTER_X + 10 * GUI_GRID_CENTER_W;
            y = GUI_GRID_CENTER_Y + 11 * GUI_GRID_CENTER_H;
            w = 20 * GUI_GRID_CENTER_W;
            h = GUI_GRID_CENTER_H;
        };

        class JoyRealismCombo : RscCombo {
            idc = IDC_RSCFZACONTROLCONFIGURATOR_JOY_REALISM_LABEL;
            class Items {
                class Realistic {
                    text = "Realistic";
                    default = 1;
                };
                class Simple {
                    text = "Simple";
                };
            };

            x = GUI_GRID_CENTER_X + 10 * GUI_GRID_CENTER_W;
            y = GUI_GRID_CENTER_Y + 12 * GUI_GRID_CENTER_H;
            w = 10 * GUI_GRID_CENTER_W;
            h = GUI_GRID_CENTER_H;
        };

        class JoyRudderLabel : RscText {
            idc = IDC_RSCFZACONTROLCONFIGURATOR_JOY_RUDDER_LABEL;
            text = "Do you use rudder pedals?";

            x = GUI_GRID_CENTER_X + 10 * GUI_GRID_CENTER_W;
            y = GUI_GRID_CENTER_Y + 14 * GUI_GRID_CENTER_H;
            w = 20 * GUI_GRID_CENTER_W;
            h = GUI_GRID_CENTER_H;
        };

        class JoyRudderCombo : RscCombo {
            idc = IDC_RSCFZACONTROLCONFIGURATOR_JOY_RUDDER_COMBO;
            class Items {
                class HasRudder {
                    text = "Rudder pedals";
                    default = 1;
                };
                class HasNoRudder {
                    text = "No rudder pedals";
                };
            };

            x = GUI_GRID_CENTER_X + 10 * GUI_GRID_CENTER_W;
            y = GUI_GRID_CENTER_Y + 15 * GUI_GRID_CENTER_H;
            w = 10 * GUI_GRID_CENTER_W;
            h = GUI_GRID_CENTER_H;
        };

        class OKButton : RscButton {
            idc = IDC_RSCFZACONTROLCONFIGURATOR_OK;


            x = GUI_GRID_CENTER_X + 25 * GUI_GRID_CENTER_W;
            y = GUI_GRID_CENTER_Y + 17 * GUI_GRID_CENTER_H;
            w = 5 * GUI_GRID_CENTER_W;
            h = GUI_GRID_CENTER_H;

            text = "OK";

            onButtonClick = "[""onOkButtonClick"", _this] call fza_sfmplus_fnc_controlConfigurator";
        };
    };
};