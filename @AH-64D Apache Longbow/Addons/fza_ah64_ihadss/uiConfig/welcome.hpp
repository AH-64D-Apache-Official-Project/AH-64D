class RscDisplayWelcome;
class RscText;
class RscFzaDisplayWelcome : RscDisplayWelcome {
    onLoad = "_this call fza_fnc_uiShowIntro";
    onUnload = "";
    idd = -1;
    class controlsBackground {
        class BackgroundLeft: RscText
        {
            colorBackground[]={0.1,0.1,0.1,1};
            x="-10";
            y="-10";
            w="safezoneX +  10";
            h="2 *  10";
        };
        class BackgroundRight: BackgroundLeft
        {
            x="safezoneX + safezoneW";
            w=10;
        };
        class TitleBackground: RscText
        {
            colorBackground[]=
            {
                "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])",
                "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])",
                "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",
                "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"
            };
            idc=1080;
            x="1 *(((safezoneW / safezoneH) min 1.2) / 40) +(safezoneX + (safezoneW -((safezoneW / safezoneH) min 1.2))/2)";
            y="1 *((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) +(safezoneY + (safezoneH -(((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
            w="38 *(((safezoneW / safezoneH) min 1.2) / 40)";
            h="1 *((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
        };
        class RightBackground: RscText
        {
            colorBackground[]={0,0,0,0.69999999};
            idc=1081;
            x="1 *(((safezoneW / safezoneH) min 1.2) / 40) +(safezoneX + (safezoneW -((safezoneW / safezoneH) min 1.2))/2)";
            y="2.1 *((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) +(safezoneY + (safezoneH -(((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
            w="38 *(((safezoneW / safezoneH) min 1.2) / 40)";
            h="20.8 *((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
        };
    };
};
