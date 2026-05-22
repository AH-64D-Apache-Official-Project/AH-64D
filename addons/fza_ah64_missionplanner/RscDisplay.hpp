class RscHTML;

class RscFzaMissionPlanner
{
    idd = 2964;
    enableSimulation = 1;
    movingEnable = 0;
    onLoad = "uiNamespace setVariable ['fza_mplanner_display', _this select 0]; (_this select 0) displayCtrl 100 ctrlHTMLLoad '\fza_ah64_missionplanner\ui\planner.html'";
    onUnload = "uiNamespace setVariable ['fza_mplanner_display', displayNull]";

    class controls
    {
        class HTMLBrowser : RscHTML
        {
            idc = 100;
            x = "safeZoneX";
            y = "safeZoneY";
            w = "safeZoneW";
            h = "safeZoneH";
        };
    };
};
