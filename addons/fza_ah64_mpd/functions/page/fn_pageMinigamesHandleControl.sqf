params ["_heli", "_mpdIndex", "_control"];

switch (_control) do {
    case "l1": {
        [_heli, _mpdIndex, "ASTEROIDS"] call fza_mpd_fnc_setCurrentPage;
    };
    case "b1": {
        [_heli, _mpdIndex, "dms"] call fza_mpd_fnc_setCurrentPage;
    };
};
