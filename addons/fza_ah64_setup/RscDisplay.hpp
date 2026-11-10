class RscText;
class RscStructuredText;

class RscFzaControlSetup
{
    idd = 2965;
    enableSimulation = 1;
    movingEnable = 0;
    onLoad = "[_this select 0] call fza_setup_fnc_onLoad";
    onUnload = "[_this select 0] call fza_setup_fnc_onUnload";

    class controlsBackground {};

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
            url = "\fza_ah64_setup\ui\setup.built.html";
            x = "safeZoneX + (safeZoneW - ((safeZoneH * 1.45) min (safeZoneW * 0.96))) * 0.5";
            y = "safeZoneY + (safeZoneH * 0.06)";
            w = "(safeZoneH * 1.45) min (safeZoneW * 0.96)";
            h = "safeZoneH * 0.88";
        };
    };
};

// Live controls test (fza_setup_fnc_test): a title layer, so the game keeps its input. Laid out in pixels at start.
class fza_setup_testText : RscText {
    idc = -1;
    x = 0; y = 0; w = 0; h = 0;
    shadow = 0;
    font = "RobotoCondensed";
    sizeEx = 0.03;
    colorText[] = {0.6, 0.85, 0.6, 1};
    colorBackground[] = {0, 0, 0, 0};
};
class fza_setup_testBox : fza_setup_testText {
    colorBackground[] = {0.3, 0.79, 0.3, 0.12};
};

class RscTitles
{
    class RscFzaSetupTest
    {
        idd = -1;
        duration = 999999;
        fadeIn = 0;
        fadeOut = 0;
        movingEnable = 0;
        onLoad = "uiNamespace setVariable ['fza_setup_testDisplay', _this select 0]";
        onUnload = "uiNamespace setVariable ['fza_setup_testDisplay', displayNull]";

        class controls
        {
            class Background : fza_setup_testText { idc = 200; colorBackground[] = {0.02, 0.04, 0.02, 0.88}; };
            class Title : fza_setup_testText { idc = 201; font = "RobotoCondensedBold"; colorText[] = {0.85, 1, 0.85, 1}; text = "CONTROLS TEST"; };
            class Help : RscStructuredText {
                idc = 202;
                x = 0; y = 0; w = 0; h = 0;
                shadow = 0;
                size = 0.04;
                colorBackground[] = {0, 0, 0, 0};
                class Attributes { font = "RobotoCondensed"; color = "#9ad79a"; align = "left"; shadow = 0; };
            };
            class CyclicBox : fza_setup_testBox { idc = 210; };
            class CyclicH : fza_setup_testBox { idc = 211; colorBackground[] = {0.3, 0.79, 0.3, 0.45}; };
            class CyclicV : CyclicH { idc = 212; };
            class CyclicDot : fza_setup_testBox { idc = 213; colorBackground[] = {0.85, 1, 0.85, 1}; };
            class CyclicLabel : fza_setup_testText { idc = 214; text = "CYCLIC"; };
            class CyclicValue : fza_setup_testText { idc = 215; };
            class CollBox : fza_setup_testBox { idc = 220; };
            class CollFill : fza_setup_testBox { idc = 221; colorBackground[] = {0.3, 0.79, 0.3, 0.9}; };
            class CollLabel : fza_setup_testText { idc = 222; text = "COLL"; };
            class PedalBox : fza_setup_testBox { idc = 230; };
            class PedalMid : CyclicH { idc = 231; };
            class PedalMark : CyclicDot { idc = 232; };
            class PedalLabel : fza_setup_testText { idc = 233; text = "PEDALS"; };
            class Buttons : Help { idc = 240; };
        };
    };
};
