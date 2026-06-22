class RscText;

class RscFzaMinigameBase {
    idd = 23963;
    onLoad = "['onLoad', _this, 'RscFzaMinigameBase'] call (missionNamespace getVariable 'fza_mg_fnc_minigameUiInit');";
    class ControlsBackground {
    };
    class Controls {
        class gameBrowser : RscText {
            type = 106; // CT_WEBBROWSER
            idc = 369;
            style = 0;
            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {1, 1, 1, 1};
            allowExternalURL = 0;
            text = "#(rgb,1,1,1)color(0,0,0,1,ca)";
            url = "about:blank";
            x = 0.025;
            y = 0.025;
            w = 0.95;
            h = 0.95;
        };
    };
};

// One small subclass per minigame, URL baked directly into config (avoids ctrlSetURL's CfgCommands whitelisting requirement).
class RscFzaMinigameAsteroids : RscFzaMinigameBase {
    idd = 23964;
    class Controls : Controls {
        class gameBrowser : gameBrowser {
            url = "\fza_ah64_minigames\ui\minigame\games\asteroids\game.html";
        };
    };
};
