class RscText;

class fza_radialLabel : RscText {
    idc = -1;
    style = 0x02;
    font = "PuristaBold";
    sizeEx = 0.032;
    shadow = 2;
    colorBackground[] = {0, 0, 0, 0};
    colorText[] = {1, 1, 1, 1};
    x = 0;
    y = 0;
    w = 0.14;
    h = 0.04;
};

// The sensor radial menu (fza_fnc_radialToggle): a child of the mission display, so the game keeps its input and the
// mouse is the menu's
class fza_radialMenu {
    idd = 23995;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "['onLoad', _this] call fza_fnc_radialDisplay";
    onUnload = "['onUnload', _this] call fza_fnc_radialDisplay";
    class ControlsBackground {
        class canvas : fza_ah64_mapControl {
            idc = 10;
            x = "safeZoneX";
            y = "safeZoneY";
            w = "safeZoneW";
            h = "safeZoneH";
            onLoad = "(_this # 0) ctrlMapAnimAdd [0, 0.001, [-999999, -999999]]; ctrlMapAnimCommit (_this # 0);";
            onDraw = "_this call fza_fnc_radialDraw";
        };
    };
    class Controls {
        // Over the canvas, so the map never takes the mouse
        class cover : RscText {
            idc = 11;
            x = "safeZoneX";
            y = "safeZoneY";
            w = "safeZoneW";
            h = "safeZoneH";
            colorBackground[] = {0, 0, 0, 0};
            text = "";
        };
    };
};
