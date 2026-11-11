class RscText;
class RscButton;

// Square in pixels: the page is 0.88 of the screen height high and as many pixels wide, centred
class RscFzaDocs
{
    idd = 2966;
    enableSimulation = 1;
    movingEnable = 0;
    onLoad = "[_this select 0] call fza_docs_fnc_onLoad";
    onUnload = "[_this select 0] call fza_docs_fnc_onUnload";

    class controlsBackground {
        class Strip : RscText {
            idc = -1;
            colorBackground[] = {0.04, 0.07, 0.04, 1};
            x = "safeZoneX + (safeZoneW - safeZoneH * 0.88 * pixelW / pixelH) * 0.5";
            y = "safeZoneY + safeZoneH * 0.915";
            w = "safeZoneH * 0.88 * pixelW / pixelH";
            h = "safeZoneH * 0.05";
        };
    };

    class controls
    {
        // The copy of the online manual written by tools/docsSnapshot.js
        class HTMLBrowser
        {
            type = 106; // CT_WEBBROWSER
            idc = 100;
            style = 0;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {1, 1, 1, 1};
            allowExternalURL = 0;
            url = "\fza_ah64_docs\ui\manual.built.html";
            x = "safeZoneX + (safeZoneW - safeZoneH * 0.88 * pixelW / pixelH) * 0.5";
            y = "safeZoneY + safeZoneH * 0.03";
            w = "safeZoneH * 0.88 * pixelW / pixelH";
            h = "safeZoneH * 0.88";
        };
        // Below the page, which would draw over it
        class Title : RscText {
            idc = 101;
            text = "AH-64D MANUAL";
            font = "RobotoCondensedBold";
            sizeEx = "safeZoneH * 0.026";
            colorText[] = {0.66, 0.86, 0.66, 1};
            x = "safeZoneX + (safeZoneW - safeZoneH * 0.86 * pixelW / pixelH) * 0.5";
            y = "safeZoneY + safeZoneH * 0.92";
            w = "safeZoneH * 0.5 * pixelW / pixelH";
            h = "safeZoneH * 0.04";
        };
        class Back : RscButton {
            idc = 104;
            text = "BACK";
            action = "[(uiNamespace getVariable ['fza_docs_display', displayNull]) displayCtrl 100, 'window.fzaDocs && window.fzaDocs.back();'] call fza_mpd_fnc_execJs";
            font = "RobotoCondensedBold";
            sizeEx = "safeZoneH * 0.024";
            colorText[] = {0.85, 1, 0.85, 1};
            colorBackground[] = {0.07, 0.17, 0.07, 1};
            colorBackgroundActive[] = {0.15, 0.44, 0.16, 1};
            colorFocused[] = {0.07, 0.17, 0.07, 1};
            colorBorder[] = {0.3, 0.79, 0.3, 1};
            x = "safeZoneX + (safeZoneW + safeZoneH * 0.88 * pixelW / pixelH) * 0.5 - safeZoneH * 0.29 * pixelW / pixelH";
            y = "safeZoneY + safeZoneH * 0.92";
            w = "safeZoneH * 0.135 * pixelW / pixelH";
            h = "safeZoneH * 0.04";
        };
        class Close : Back {
            idc = 103;
            text = "CLOSE";
            action = "closeDialog 2";
            colorBackground[] = {0.11, 0.32, 0.11, 1};
            colorFocused[] = {0.11, 0.32, 0.11, 1};
            x = "safeZoneX + (safeZoneW + safeZoneH * 0.88 * pixelW / pixelH) * 0.5 - safeZoneH * 0.145 * pixelW / pixelH";
        };
    };
};
