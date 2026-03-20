params ["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"
#include "\fza_ah64_dms\headers\constants.h"


_heli setUserMfdText [MFD_INDEX_OFFSET(0), "TESTING"];
_heli setUserMfdValue [MFD_INDEX_OFFSET(0), 11];

_heli setUserMfdText [MFD_INDEX_OFFSET(1), "TESTING"];
_heli setUserMfdValue [MFD_INDEX_OFFSET(1), 22];

_heli setUserMfdText [MFD_INDEX_OFFSET(2), "TESTING"];
_heli setUserMfdValue [MFD_INDEX_OFFSET(2), 33];