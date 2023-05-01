params ["_heli", "_mpdIndex", "_state"];
#include "\fza_ah64_mpd\headers\mfdConstants.h"
#include "\fza_ah64_controls\headers\wcaConstants.h"

_heli setUserMfdValue [MFD_INDEX_OFFSET(MFD_IND_DTU_SUBPAGE), _state get "subPageVarPage" select 0];