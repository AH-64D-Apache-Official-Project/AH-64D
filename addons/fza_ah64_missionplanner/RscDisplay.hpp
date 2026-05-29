class RscFzaMissionPlanner
{
    idd = 2964;
    enableSimulation = 1;
    movingEnable = 0;
    onLoad = "[_this select 0] spawn fza_mplanner_fnc_onLoad";
    onUnload = "uiNamespace setVariable ['fza_mplanner_display', displayNull]";

    class controlsBackground
    {
        class PanelBackground
        {
            idc = -1;
            type = 0;
            style = 0;
            text = "";
            x = "safeZoneX + ((safeZoneW - (safeZoneH * 1.28)) * 0.5)";
            y = "safeZoneY + (safeZoneH * 0.10)";
            w = "safeZoneH * 1.28";
            h = "safeZoneH * 0.80";
            colorBackground[] = {0, 0, 0, 0.0};
        };
    };

    class controls
    {
        class HTMLBrowser
        {
            type = 106; // CT_WEBBROWSER
            idc = 100;
            style = 0;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {1, 1, 1, 1};
            allowExternalURL = 0;
            url = "\fza_ah64_missionplanner\ui\planner.html";
            x = "safeZoneX + ((safeZoneW - (safeZoneH * 1.20)) * 0.5)";
            y = "safeZoneY + (safeZoneH * 0.14)";
            w = "safeZoneH * 1.20";
            h = "safeZoneH * 0.72";
        };
    };
};
