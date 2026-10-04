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
        [_heli, "pitch", !(_heli getVariable "bmkhs_fmcPitchOn")] call bmkhs_fnc_fmcSetChannel;
    };
    //Roll
    case "l2": {
        [_heli, "roll", !(_heli getVariable "bmkhs_fmcRollOn")] call bmkhs_fnc_fmcSetChannel;
    };
    //Yaw
    case "l3": {
        [_heli, "yaw", !(_heli getVariable "bmkhs_fmcYawOn")] call bmkhs_fnc_fmcSetChannel;
    };
    //Coll
    case "l4": {
        [_heli, "coll", !(_heli getVariable "bmkhs_fmcCollOn")] call bmkhs_fnc_fmcSetChannel;
    };
    //Trim
    case "l5": {
        [_heli, "trim", !(_heli getVariable "bmkhs_fmcTrimOn")] call bmkhs_fnc_fmcSetChannel;
    };

    case "b1": {
        [_heli, _mpdIndex, "menu"] call fza_mpd_fnc_setCurrentPage;
    };
};
