class fza_ah64_mapControl;
class RscTitles
{
    class fza_ah64_ihadssHtml
    {
        idd = 650;
        movingEnable = 0;
        duration     = 99999;
        fadein       = 0;
        fadeout      = 0;
        name = "fza_ah64_ihadssHtml";
        onLoad = "uiNamespace setVariable ['fza_ah64_ihadssHtml', _this select 0]; (_this select 0) setVariable ['fza_ihadss_browserRect', uiNamespace getVariable ['fza_ihadss_browserRect', []]];";
        class controls
        {
            class Browser
            {
                idc = 960;
                type = 106; // CT_WEBBROWSER
                style = 0;
                colorBackground[] = {0, 0, 0, 0};
                colorText[] = {1, 1, 1, 1};
                allowExternalURL = 0;
                url = "\fza_ah64_ihadss\ui\ihadss_built.html";
                // Created at its final size, set by fza_ihadss_fnc_htmlDraw before opening the layer, and never resized
                x = "(uiNamespace getVariable ['fza_ihadss_browserRect', [safeZoneX + safeZoneW * 0.25, 0, 0, 0]]) select 0";
                y = "(uiNamespace getVariable ['fza_ihadss_browserRect', [0, safeZoneY + safeZoneH * 0.25, 0, 0]]) select 1";
                w = "(uiNamespace getVariable ['fza_ihadss_browserRect', [0, 0, safeZoneW * 0.5, 0]]) select 2";
                h = "(uiNamespace getVariable ['fza_ihadss_browserRect', [0, 0, 0, safeZoneH * 0.5]]) select 3";
            };
        };
    };
    // The CPG's heads down page, kept loaded beside the heads up one so switching views never resizes or reloads a browser
    class fza_ah64_ihadssHtmlDown
    {
        idd = 654;
        movingEnable = 0;
        duration     = 99999;
        fadein       = 0;
        fadeout      = 0;
        name = "fza_ah64_ihadssHtmlDown";
        onLoad = "uiNamespace setVariable ['fza_ah64_ihadssHtmlDown', _this select 0]; (_this select 0) setVariable ['fza_ihadss_browserRect', uiNamespace getVariable ['fza_ihadss_browserRectDown', []]];";
        class controls
        {
            class Browser
            {
                idc = 960;
                type = 106; // CT_WEBBROWSER
                style = 0;
                colorBackground[] = {0, 0, 0, 0};
                colorText[] = {1, 1, 1, 1};
                allowExternalURL = 0;
                url = "\fza_ah64_ihadss\ui\ihadss_built.html";
                x = "(uiNamespace getVariable ['fza_ihadss_browserRectDown', [safeZoneX, 0, 0, 0]]) select 0";
                y = "(uiNamespace getVariable ['fza_ihadss_browserRectDown', [0, safeZoneY, 0, 0]]) select 1";
                w = "(uiNamespace getVariable ['fza_ihadss_browserRectDown', [0, 0, safeZoneW, 0]]) select 2";
                h = "(uiNamespace getVariable ['fza_ihadss_browserRectDown', [0, 0, 0, safeZoneH]]) select 3";
            };
        };
    };
    class fza_ah64_ihadssIcons
    {
        idd = 651;
        movingEnable = 0;
        duration     = 99999;
        fadein       = 0;
        fadeout      = 0;
        name = "fza_ah64_ihadssIcons";
        onLoad = "uiNamespace setVariable ['fza_ah64_ihadssIcons', _this select 0];";
        class controls
        {
            // TPM profile lines (fza_ihadss_fnc_cscopeProfileDraw), drawn in screen coordinates under the icons
            class Profile: fza_ah64_mapControl
            {
                idc = 652;
                x = "safeZoneX";
                y = "safeZoneY";
                w = "safeZoneW";
                h = "safeZoneH";
                // Faded until the view far off the map has applied, a new map first draws its default view with icons and names;
                // fza_ihadss_fnc_htmlIcons shows it
                fade = 1;
                onLoad = "(_this # 0) ctrlMapAnimAdd [0, 0.001, [-99999, -99999]]; ctrlMapAnimCommit (_this # 0);";
                onDraw = "_this call fza_ihadss_fnc_cscopeProfileDraw";
            };
        };
    };
    class fza_ah64_nvsoverlay
    {
        idd = 800;
        movingEnable =  1;
        duration     =  99999;
        fadein       =  0;
        fadeout      =  0;
        name = "fza_ah64_nvsoverlay";
        onLoad = "uiNameSpace setvariable ['fza_ah64_nvsoverlay',_this select 0];";
        // Built from PNVS picture strips by fza_ihadss_fnc_hduPnvsMask
        class controls {};
    };
    class fza_ah64_monocleinbox
    {
        idd = 500;
        movingEnable =  1;
        duration     =  99999;
        fadein       =  0;
        fadeout      =  0;
        name = "fza_ah64_monocleinbox";
        onLoad = "uiNameSpace setvariable ['fza_ah64_monocleinbox',_this select 0];";
        
        class controls
        {
            class fza_ah64_monocle
            {
                idc = 501;
                type = 0;
                colorText[] = {1,1,1,1};
                font = "EtelkaMonospaceProBold";
                colorBackground[] = {1, 1, 1, 1};
                text = "";
                style = 48;
                sizeEx = 1;
                x = __EVAL((ICE_HUD_SCX-ICE_HUD_Monocle_Size)*0.2 + 0.15);
                y = __EVAL((ICE_HUD_SCY-ICE_HUD_Monocle_Size)*0.2);
                w = __EVAL(ICE_HUD_Monocle_Size*0.707);
                h = ICE_HUD_Monocle_Size;
            };
        };
    };
};
