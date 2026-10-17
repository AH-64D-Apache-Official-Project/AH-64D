params["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"

private _gunMode = [_heli, "fza_ah64_gunMode"] call fza_fnc_getSeatVariable;
_heli setUserMFDText [MFD_INDEX_OFFSET(MFD_TEXT_IND_WPN_GUN_MODE), [_gunMode, "NORM"] select (isNil "_gunMode")];

switch (_heli getVariable "fza_ah64_burst_limit") do {
    case 10: {
        _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_WPN_GUN_BURST_LIMIT), 0];
    };
    case 20: {
        _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_WPN_GUN_BURST_LIMIT), 1];
    };
    case 50: {
        _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_WPN_GUN_BURST_LIMIT), 2];
    };
    case 100: {
        _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_WPN_GUN_BURST_LIMIT), 3];
    };
    case -1: {
        _heli setUserMFDValue [MFD_INDEX_OFFSET(MFD_IND_WPN_GUN_BURST_LIMIT), 4];
    };
};
