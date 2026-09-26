// fza_mg_fnc_minigameNetLeaveAll - calls fza_mg_fnc_minigameNetLeave for every known net-aware game (harmless
// no-op for any game the local player doesn't have an active session in). Centralizes the game-id list so it
// only needs updating in one place when a new 2-player game is added.
{[_x] call fza_mg_fnc_minigameNetLeave;} forEach ["pong", "battleship", "tictactoe", "connectfour", "rockpaperscissors", "checkers"];
