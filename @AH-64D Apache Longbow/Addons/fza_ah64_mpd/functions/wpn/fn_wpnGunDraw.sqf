params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

switch (_heli getVariable "fza_ah64_burst_limit") do {
    case 10: {
        [_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_GUN_BURST_LIMIT), 0] call fza_mpd_fnc_updateMfdValue;
    };
    case 20: {
        [_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_GUN_BURST_LIMIT), 1] call fza_mpd_fnc_updateMfdValue;
    };
    case 50: {
        [_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_GUN_BURST_LIMIT), 2] call fza_mpd_fnc_updateMfdValue;
    };
    case 100: {
        [_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_GUN_BURST_LIMIT), 3] call fza_mpd_fnc_updateMfdValue;
    };
    case -1: {
        [_heli, MFD_INDEX_OFFSET(MFD_IND_WPN_GUN_BURST_LIMIT), 4] call fza_mpd_fnc_updateMfdValue;
    };
};