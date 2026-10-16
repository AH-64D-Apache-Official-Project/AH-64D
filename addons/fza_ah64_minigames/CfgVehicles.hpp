#include "\fza_ah64_mpd\headers\mfdConstants.h"
// Minigame pages for the MPD page list; the menu page (MINIGAMES) stays in fza_ah64_mpd
class CfgVehicles {
    class Helicopter_Base_F;
    class fza_ah64base : Helicopter_Base_F {
        class FzaMpdPages {
            class ASTEROIDS {
                index = MPD_PAGE_ASTEROIDS;
                htmlUrl = "\fza_ah64_minigames\ui\minigame\games\asteroids\game.html";
                htmlClass = "RscFzaMinigameAsteroids";
                handleControl = "fza_mg_fnc_minigameHandleControl";
            };
            class SPACEINVADERS {
                index = MPD_PAGE_SPACEINVADERS;
                htmlUrl = "\fza_ah64_minigames\ui\minigame\games\spaceinvaders\game.html";
                htmlClass = "RscFzaMinigameSpaceInvaders";
                handleControl = "fza_mg_fnc_minigameHandleControl";
            };
            class PONG {
                index = MPD_PAGE_PONG;
                htmlUrl = "\fza_ah64_minigames\ui\minigame\games\pong\game.html";
                htmlClass = "RscFzaMinigamePong";
                handleControl = "fza_mg_fnc_minigameHandleControl";
            };
            class BREAKOUT {
                index = MPD_PAGE_BREAKOUT;
                htmlUrl = "\fza_ah64_minigames\ui\minigame\games\breakout\game.html";
                htmlClass = "RscFzaMinigameBreakout";
                handleControl = "fza_mg_fnc_minigameHandleControl";
            };
            class LUNARLANDER {
                index = MPD_PAGE_LUNARLANDER;
                htmlUrl = "\fza_ah64_minigames\ui\minigame\games\lunarlander\game.html";
                htmlClass = "RscFzaMinigameLunarLander";
                handleControl = "fza_mg_fnc_minigameHandleControl";
            };
            class BATTLESHIP {
                index = MPD_PAGE_BATTLESHIP;
                htmlUrl = "\fza_ah64_minigames\ui\minigame\games\battleship\game.html";
                htmlClass = "RscFzaMinigameBattleship";
                handleControl = "fza_mg_fnc_minigameHandleControl";
            };
            class TICTACTOE {
                index = MPD_PAGE_TICTACTOE;
                htmlUrl = "\fza_ah64_minigames\ui\minigame\games\tictactoe\game.html";
                htmlClass = "RscFzaMinigameTicTacToe";
                handleControl = "fza_mg_fnc_minigameHandleControl";
            };
            class CONNECTFOUR {
                index = MPD_PAGE_CONNECTFOUR;
                htmlUrl = "\fza_ah64_minigames\ui\minigame\games\connectfour\game.html";
                htmlClass = "RscFzaMinigameConnectFour";
                handleControl = "fza_mg_fnc_minigameHandleControl";
            };
            class ROCKPAPERSCISSORS {
                index = MPD_PAGE_ROCKPAPERSCISSORS;
                htmlUrl = "\fza_ah64_minigames\ui\minigame\games\rockpaperscissors\game.html";
                htmlClass = "RscFzaMinigameRockPaperScissors";
                handleControl = "fza_mg_fnc_minigameHandleControl";
            };
            class CHECKERS {
                index = MPD_PAGE_CHECKERS;
                htmlUrl = "\fza_ah64_minigames\ui\minigame\games\checkers\game.html";
                htmlClass = "RscFzaMinigameCheckers";
                handleControl = "fza_mg_fnc_minigameHandleControl";
            };
        };
    };
};
