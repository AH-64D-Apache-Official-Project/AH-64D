class RscFzaMissionPlanner
{
    idd = 2964;
    enableSimulation = 1;
    movingEnable = 0;
    onLoad = "[_this select 0] call fza_mplanner_fnc_onLoad";
    onUnload = "uiNamespace setVariable ['fza_mplanner_display', displayNull]; uiNamespace setVariable ['fza_mplanner_dtcDraw', nil]; uiNamespace setVariable ['fza_mplanner_dtcDraft', nil]; uiNamespace setVariable ['fza_mplanner_dtcPoints', nil]; uiNamespace setVariable ['fza_mplanner_dtcRoute', nil]";

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
            colorText[] = {1, 1, 1, 0};
            font = "PuristaMedium";
            sizeEx = 0;
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
            url = "\fza_ah64_missionplanner\ui\planner.built.html";
            x = "safeZoneX + ((safeZoneW - (safeZoneH * 1.20)) * 0.5)";
            y = "safeZoneY + (safeZoneH * 0.14)";
            w = "safeZoneH * 1.20";
            h = "safeZoneH * 0.72";
        };
        // The DTC map, over the browser's map area (fza_mplanner_fnc_dtcMap)
        class DtcMap: RscMapControl
        {
            idc = 101;
            x = 0;
            y = 0;
            w = 0;
            h = 0;
            maxSatelliteAlpha = 0.6;
        };
    };
};
