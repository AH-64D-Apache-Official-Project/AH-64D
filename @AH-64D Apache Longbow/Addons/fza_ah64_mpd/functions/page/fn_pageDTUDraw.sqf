params ["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_mpd\headers\tsd.hpp"
#include "\fza_ah64_dms\headers\constants.h"

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_DTU_SUBPAGE), _state get "subPage"];
_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_DTU_LOAD_STATUS), _state get "loadState"]