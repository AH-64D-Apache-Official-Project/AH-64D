//The lit face of the TAIL WHEEL buttons, rendered onto plt_tw_button and cpg_tw_button through a
//2048 ui() texture (fn_coreControlHandle). Same font and colour as the EMER HYD legend. Both faces
//sample U 0.652-0.899, V 0.418-0.666 of their texture, so the legend is drawn there and nowhere else.
class RscText;
class RscFzaAH64TwUnlocked {
    idd = -1;
    class controls {
        class unlocked: RscText {
            idc = -1;
            style = 0x02;
            text = "UNLOCKED";
            font = "fza_ticketing";
            sizeEx = 0.045;
            shadow = 0;
            colorText[] = {0.0, 0.80, 0.51, 1};
            colorBackground[] = {0, 0, 0, 1};
            x = 0.652;
            y = 0.418;
            w = 0.247;
            h = 0.248;
        };
    };
};
