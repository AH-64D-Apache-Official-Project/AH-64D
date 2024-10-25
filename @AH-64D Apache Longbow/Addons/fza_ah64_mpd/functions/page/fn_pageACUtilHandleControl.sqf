#include "\fza_ah64_controls\headers\script_common.hpp"
params ["_heli", "_mpdIndex", "_control"];

switch(_control) do {
    case "t2": {
        [_heli, _mpdIndex, "flt"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t3": {
        [_heli, _mpdIndex, "fuel"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t4": {
        [_heli, _mpdIndex, "perf"] call fza_mpd_fnc_setCurrentPage;
    };
    case "t6": {
        [_heli, _mpdIndex, "eng"] call fza_mpd_fnc_setCurrentPage;
    };

    //Pitch
    case "l1": {
        _heli setVariable ["fza_ah64_fmcPitchOn", !(_heli getVariable "fza_ah64_fmcPitchOn"), true];
    };
    //Roll
    case "l2": {
        _heli setVariable ["fza_ah64_fmcRollOn", !(_heli getVariable "fza_ah64_fmcRollOn"), true];
    };
    //Yaw
    case "l3": {
        _heli setVariable ["fza_ah64_fmcYawOn", !(_heli getVariable "fza_ah64_fmcYawOn"), true];
    };
    //Coll
    case "l4": {
        _heli setVariable ["fza_ah64_fmcCollOn", !(_heli getVariable "fza_ah64_fmcCollOn"), true];
    };
    //Trim
    case "l5": {
        _heli setVariable ["fza_ah64_fmcTrimOn", !(_heli getVariable "fza_ah64_fmcTrimOn"), true];
    };

    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };
};