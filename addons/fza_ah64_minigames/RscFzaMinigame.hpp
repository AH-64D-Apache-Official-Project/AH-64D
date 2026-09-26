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

class RscFzaMinigameSpaceInvaders : RscFzaMinigameBase {
    idd = 23965;
    class Controls : Controls {
        class gameBrowser : gameBrowser {
            url = "\fza_ah64_minigames\ui\minigame\games\spaceinvaders\game.html";
        };
    };
};

class RscFzaMinigamePong : RscFzaMinigameBase {
    idd = 23966;
    class Controls : Controls {
        class gameBrowser : gameBrowser {
            url = "\fza_ah64_minigames\ui\minigame\games\pong\game.html";
        };
    };
};

class RscFzaMinigameBreakout : RscFzaMinigameBase {
    idd = 23967;
    class Controls : Controls {
        class gameBrowser : gameBrowser {
            url = "\fza_ah64_minigames\ui\minigame\games\breakout\game.html";
        };
    };
};

class RscFzaMinigameLunarLander : RscFzaMinigameBase {
    idd = 23968;
    class Controls : Controls {
        class gameBrowser : gameBrowser {
            url = "\fza_ah64_minigames\ui\minigame\games\lunarlander\game.html";
        };
    };
};

class RscFzaMinigameBattleship : RscFzaMinigameBase {
    idd = 23969;
    class Controls : Controls {
        class gameBrowser : gameBrowser {
            url = "\fza_ah64_minigames\ui\minigame\games\battleship\game.html";
        };
    };
};

class RscFzaMinigameTicTacToe : RscFzaMinigameBase {
    idd = 23970;
    class Controls : Controls {
        class gameBrowser : gameBrowser {
            url = "\fza_ah64_minigames\ui\minigame\games\tictactoe\game.html";
        };
    };
};

class RscFzaMinigameConnectFour : RscFzaMinigameBase {
    idd = 23971;
    class Controls : Controls {
        class gameBrowser : gameBrowser {
            url = "\fza_ah64_minigames\ui\minigame\games\connectfour\game.html";
        };
    };
};

class RscFzaMinigameRockPaperScissors : RscFzaMinigameBase {
    idd = 23972;
    class Controls : Controls {
        class gameBrowser : gameBrowser {
            url = "\fza_ah64_minigames\ui\minigame\games\rockpaperscissors\game.html";
        };
    };
};

class RscFzaMinigameCheckers : RscFzaMinigameBase {
    idd = 23973;
    class Controls : Controls {
        class gameBrowser : gameBrowser {
            url = "\fza_ah64_minigames\ui\minigame\games\checkers\game.html";
        };
    };
};
