#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli", "_mpdIndex", "_control"];

switch(_control) do {
    case "t2": {
        [_heli, _mpdIndex, "flt"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t3": {
        [_heli, _mpdIndex, "eng"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t4": {
        [_heli, _mpdIndex, "perf"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t6": {
        [_heli, _mpdIndex, "acutil"] call fza_mpd_fnc_setCurrentPage;
    };   
    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };

    if (_heli getVariable "fza_ah64_IAFSInstalled") then {
        case "l2": {
            _heli setVariable ["fza_ah64_IAFSOn", !(_heli getVariable "fza_ah64_IAFSOn")];
        };
    };
};