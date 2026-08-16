params ["_heli", "_mpdIndex", "_control"];

switch (_control) do {
    case "l1": {
        [_heli, _mpdIndex, "ASTEROIDS"] call fza_mpd_fnc_setCurrentPage;
    };
    case "l2": {
        [_heli, _mpdIndex, "SPACEINVADERS"] call fza_mpd_fnc_setCurrentPage;
    };
    case "l3": {
        [_heli, _mpdIndex, "BREAKOUT"] call fza_mpd_fnc_setCurrentPage;
    };
    case "l4": {
        [_heli, _mpdIndex, "LUNARLANDER"] call fza_mpd_fnc_setCurrentPage;
    };
    case "r1": {
        [_heli, _mpdIndex, "PONG"] call fza_mpd_fnc_setCurrentPage;
    };
    case "r2": {
        [_heli, _mpdIndex, "BATTLESHIP"] call fza_mpd_fnc_setCurrentPage;
    };
    case "r3": {
        [_heli, _mpdIndex, "TICTACTOE"] call fza_mpd_fnc_setCurrentPage;
    };
    case "r4": {
        [_heli, _mpdIndex, "CONNECTFOUR"] call fza_mpd_fnc_setCurrentPage;
    };
    case "r5": {
        [_heli, _mpdIndex, "ROCKPAPERSCISSORS"] call fza_mpd_fnc_setCurrentPage;
    };
    case "r6": {
        [_heli, _mpdIndex, "CHECKERS"] call fza_mpd_fnc_setCurrentPage;
    };
    case "b1": {
        [_heli, _mpdIndex, "dms"] call fza_mpd_fnc_setCurrentPage;
    };
    case "b2": {
        [_heli, _mpdIndex, "DOOM"] call fza_mpd_fnc_setCurrentPage;
    };
};
