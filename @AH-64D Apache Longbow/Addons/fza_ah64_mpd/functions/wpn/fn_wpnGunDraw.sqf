params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

switch (_heli getVariable "fza_ah64_burst_limit") do {
    case 10: {
        _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_GUN_BURST_LIMIT), 0];
    };
    case 20: {
        _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_GUN_BURST_LIMIT), 1];
    };
    case 50: {
        _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_GUN_BURST_LIMIT), 2];
    };
    case 100: {
        _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_GUN_BURST_LIMIT), 3];
    };
    case -1: {
        _heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_WPN_GUN_BURST_LIMIT), 4];
    };
};